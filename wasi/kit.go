package main

import (
	"context"

	// FIXME: this is used to disable log on console, so we should
	// keep this import alone and before other third party import
	// to avoid go fmt placing it behind the packages that print log
	// to console.
	_ "github.com/pingcap/tidb-wasm/wasi/init"

	"github.com/pingcap/errors"
	"github.com/pingcap/parser/auth"
	"github.com/pingcap/tidb/executor"
	"github.com/pingcap/tidb/kv"
	"github.com/pingcap/tidb/session"
	"github.com/pingcap/tidb/util/sqlexec"
)

// Kit is a utility to run sql.
type Kit struct {
	session session.Session
}

// NewKit returns a new *Kit.
func NewKit(store kv.Storage) *Kit {
	kit := &Kit{}

	if se, err := session.CreateSession(store); err != nil {
		panic(err)
	} else {
		kit.session = se
	}
	if !kit.session.Auth(&auth.UserIdentity{
		Username:     "root",
		Hostname:     "localhost",
		AuthUsername: "root",
		AuthHostname: "localhost",
	}, nil, nil) {
		panic("auth failed")
	}

	return kit
}

// Exec executes a sql statement.
func (k *Kit) Exec(sql string) (sqlexec.RecordSet, error) {
	ctx := context.Background()
	rss, err := k.session.Execute(ctx, sql)
	if err == nil && len(rss) > 0 {
		return rss[0], nil
	}

	if err != nil {
		return nil, errors.Trace(err)
	}

	loadStats := k.session.Value(executor.LoadStatsVarKey)
	if loadStats != nil {
		defer k.session.SetValue(executor.LoadStatsVarKey, nil)
		if err := k.handleLoadStats(ctx, loadStats.(*executor.LoadStatsInfo)); err != nil {
			return nil, errors.Trace(err)
		}
	}

	loadDataInfo := k.session.Value(executor.LoadDataVarKey)
	if loadDataInfo != nil {
		defer k.session.SetValue(executor.LoadDataVarKey, nil)
		if err = handleLoadData(ctx, k.session, loadDataInfo.(*executor.LoadDataInfo)); err != nil {
			return nil, err
		}
	}

	return nil, nil
}

// ExecFile let user upload a file and execute sql statements from that file.
func (k *Kit) ExecFile() error {
	panic("not implement yet")
	return nil
}

// ResultSetToStringSlice converts sqlexec.RecordSet to string slice slices.
func (k *Kit) ResultSetToStringSlice(rs sqlexec.RecordSet) ([][]string, error) {
	return session.ResultSetToStringSlice(context.Background(), k.session, rs)
}

// handleLoadData does the additional work after processing the 'load data' query.
// It let user upload a file, then reads the file content, inserts data into database.
func handleLoadData(ctx context.Context, se session.Session, loadDataInfo *executor.LoadDataInfo) error {
	panic("not implement yet")
	return nil
}

// handleLoadStats does the additional work after processing the 'load stats' query.
// It let user upload a file, then reads the file content, loads it into the storage.
func (k *Kit) handleLoadStats(ctx context.Context, loadStatsInfo *executor.LoadStatsInfo) error {
	panic("not implement yet")
	return nil
}
