package main

import (
	"fmt"
	"runtime"
	"time"

	"github.com/pingcap/tidb/session"
	"github.com/pingcap/tidb/store/mockstore"
	"github.com/pingcap/tidb/store/mockstore/mocktikv"
)

// Initialize a store and return a *Kit
func setup() *Kit {
	cluster := mocktikv.NewCluster()
	mocktikv.BootstrapWithSingleStore(cluster)
	mvccStore := mocktikv.MustNewMVCCStore()
	store, err := mockstore.NewMockTikvStore(
		mockstore.WithCluster(cluster),
		mockstore.WithMVCCStore(mvccStore),
	)
	if err != nil {
		panic("create mock tikv store failed")
	}
	session.SetSchemaLease(0)
	session.SetStatsLease(0)
	if _, err := session.BootstrapSession(store); err != nil {
		panic("bootstrap session failed")
	}
	return NewKit(store)
}

func main() {
	k := setup()
	term := NewTerm()

	for {
		sql := term.Read()
		runtime.Gosched()
		start := time.Now()
		ret := ""
		if sql == "" {
			continue
		}
		if rs, err := k.Exec(sql); err != nil {
			ret += term.Error(err)
		} else if rs == nil {
			ret += term.WriteEmpty(time.Now().Sub(start))
		} else if rows, err := k.ResultSetToStringSlice(rs); err != nil {
			ret += term.Error(err)
		} else {
			msg := term.WriteRows(rs.Fields(), rows, time.Now().Sub(start))
			ret += msg
		}
		fmt.Println(ret)
	}
}
