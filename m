From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH 2/2] scsi: qla2xxx: Fix a small typo in qla_bsg.c
Date: Tue, 12 Mar 2019 18:23:15 +0530
Message-ID: <20190312125315.GA13975@machine1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org

Fixed a typo for 'iiDMA' cmd in qla_bsg.c

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 17d42658ad9a..f2b95f11a71c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1354,7 +1354,7 @@ qla24xx_iidma(struct bsg_job *bsg_job)
 
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x704c,
-		    "iIDMA cmd failed for %8phN -- "
+		    "iiDMA cmd failed for %8phN -- "
 		    "%04x %x %04x %04x.\n", fcport->port_name,
 		    rval, fcport->fp_speed, mb[0], mb[1]);
 		rval = (DID_ERROR << 16);
