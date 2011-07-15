From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 02/16] SCSI: NCR53c406a: Remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:19:43 -0400
Message-ID: <1310710783.3184.53.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/NCR53c406a.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..62e0aaf 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -201,7 +201,7 @@ static int dma_chan;
 static int fast_pio = USE_FAST_PIO;
 #endif
 
-static Scsi_Cmnd *current_SC;
+static struct scsi_cmnd *current_SC;
 static char info_msg[256];
 
 /* ================================================================= */
@@ -693,7 +693,7 @@ static void wait_intr(void)
 }
 #endif
 
-static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int NCR53c406a_queue_lck(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	int i;
 
@@ -728,7 +728,7 @@ static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 static DEF_SCSI_QCMD(NCR53c406a_queue)
 
-static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
+static int NCR53c406a_host_reset(struct scsi_cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
 
-- 
1.7.4.1
