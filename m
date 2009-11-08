From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 02/20] scsi/NCR53c406a No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:00 -0300
Message-ID: <1257711420.4759.108.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755434AbZKHU0V@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, normunds@fi.ibm.com
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

--- 
drivers/scsi/NCR53c406a.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6961f78..8ef7dc9 100644
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
 
-static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int NCR53c406a_queue(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	int i;
 
@@ -726,7 +726,7 @@ static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	return 0;
 }
 
-static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
+static int NCR53c406a_host_reset(struct scsi_cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
 
