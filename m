From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 43/73] scsi: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:46 -0500
Message-ID: <1390339396-3479-44-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/aacraid/aachba.c               | 1 -
 drivers/scsi/aacraid/commctrl.c             | 1 -
 drivers/scsi/aacraid/comminit.c             | 1 -
 drivers/scsi/aacraid/commsup.c              | 1 -
 drivers/scsi/aacraid/dpcsup.c               | 1 -
 drivers/scsi/aacraid/rx.c                   | 1 -
 drivers/scsi/aacraid/sa.c                   | 1 -
 drivers/scsi/aacraid/src.c                  | 1 -
 drivers/scsi/arcmsr/arcmsr_attr.c           | 1 -
 drivers/scsi/arm/msgqueue.c                 | 1 -
 drivers/scsi/arm/queue.c                    | 1 -
 drivers/scsi/bnx2fc/bnx2fc.h                | 1 -
 drivers/scsi/csiostor/csio_attr.c           | 1 -
 drivers/scsi/fdomain.c                      | 1 -
 drivers/scsi/fnic/fnic_scsi.c               | 1 -
 drivers/scsi/hosts.c                        | 1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c         | 1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c       | 1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          | 1 -
 drivers/scsi/mpt2sas/mpt2sas_transport.c    | 1 -
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 1 -
 drivers/scsi/mpt3sas/mpt3sas_config.c       | 1 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 1 -
 drivers/scsi/mpt3sas/mpt3sas_transport.c    | 1 -
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c | 1 -
 drivers/scsi/qla2xxx/qla_def.h              | 1 -
 drivers/scsi/qla4xxx/ql4_def.h              | 1 -
 drivers/scsi/scsi_scan.c                    | 1 -
 drivers/scsi/scsi_sysfs.c                   | 1 -
 drivers/scsi/ufs/ufshcd.h                   | 1 -
 drivers/scsi/wd33c93.c                      | 1 -
 31 files changed, 31 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 681434e..c0e8b9e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index fbcd48d..abb98dc5 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 177b094..bbe5077 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index cab190a..e8ed86f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index d81b281..130939c 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index dada38a..bdda9e8 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 2244f31..585a855 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7e17107..7afb2b0 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index acdae33..f3978f8 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -46,7 +46,6 @@
 */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/arm/msgqueue.c b/drivers/scsi/arm/msgqueue.c
index 7c95c75..bcae7f0 100644
--- a/drivers/scsi/arm/msgqueue.c
+++ b/drivers/scsi/arm/msgqueue.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/init.h>
 
 #include "msgqueue.h"
 
diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index cb11cce..7ee1090 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/init.h>
 
 #include "../scsi.h"
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 1ebf3fb..b753030 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -30,7 +30,6 @@
 #include <linux/timer.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index 065a87a..0a50452 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -36,7 +36,6 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/mm.h>
 #include <linux/jiffies.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index fff6829..2b45368 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -267,7 +267,6 @@
  **************************************************************************/
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0521436..697ba76 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -17,7 +17,6 @@
  */
 #include <linux/mempool.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f28ea07..fb7be2b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -28,7 +28,6 @@
 #include <linux/kthread.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..ab8c981 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -45,7 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 0c47425..2fb88e9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -43,7 +43,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/blkdev.h>
 #include <linux/sched.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index b7f887c..3b06d45 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -45,7 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 410f4a3..3c6c23a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -43,7 +43,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..6f2a90c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -45,7 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 936ec03..e1712a6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -43,7 +43,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/blkdev.h>
 #include <linux/sched.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 9b89de1..9b2b4b4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -45,7 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 65170cb..ab69795 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -43,7 +43,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index f6533ab..1560a53 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -45,7 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1fe95e..79bee11 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -8,7 +8,6 @@
 #define __QLA_DEF_H
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/list.h>
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index aa67bb9..2c1d8db 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -9,7 +9,6 @@
 #define __QL4_DEF_H
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/list.h>
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..7b02567 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -27,7 +27,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..3fb9557 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 577679a..c63f717 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -38,7 +38,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/delay.h>
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 41883a8..3585315 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -80,7 +80,6 @@
 
 #include <linux/string.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 
-- 
1.8.4.1
