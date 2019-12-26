package init

import (
	"github.com/pingcap/log"
	"github.com/pingcap/tidb/util/logutil"
	"github.com/sirupsen/logrus"
	"go.uber.org/zap"
)

func init() {
	log.SetLevel(zap.FatalLevel)
	logutil.SlowQueryLogger.SetLevel(logrus.PanicLevel)
}
