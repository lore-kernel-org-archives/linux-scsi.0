From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 17/20] scsi/pas16: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:28 -0300
Message-ID: <1257711448.4759.123.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755406AbZKHU0N@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, drew@colorado.edu
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/pas16.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index 8dc5b1a..dc87366 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -114,12 +114,12 @@
 

 #ifndef ASM
-static int pas16_abort(Scsi_Cmnd *);
+static int pas16_abort(struct scsi_cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
 static int pas16_detect(struct scsi_host_template *);
-static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int pas16_bus_reset(Scsi_Cmnd *);
+static int pas16_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int pas16_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
