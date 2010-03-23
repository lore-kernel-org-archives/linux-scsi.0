From: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module parameter
Date: Tue, 23 Mar 2010 18:14:59 +0100
Message-ID: <87634n0xkc.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..ac08397 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -69,8 +69,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
-		"Enables FDMI registratons "
-		"Default is 0 - no FDMI. 1 - perfom FDMI.");
+		"Enables FDMI registrations. "
+		"0 - no FDMI. Default is 1 - perform FDMI.");
 
 #define MAX_Q_DEPTH    32
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
-- 
1.5.6.5
