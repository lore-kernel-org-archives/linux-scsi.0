From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 14/16] SCSI: wd7000: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:35 -0400
Message-ID: <1310710835.3184.65.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Miroslav Zagorac <zaga@fly.cc.fer.hr>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/wd7000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..6127672 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1568,7 +1568,7 @@ static int wd7000_release(struct Scsi_Host *shost)
 /*
  *  I have absolutely NO idea how to do an abort with the WD7000...
  */
-static int wd7000_abort(Scsi_Cmnd * SCpnt)
+static int wd7000_abort(struct scsi_cmnd * SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-- 
1.7.4.1
