From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] make drivers/scsi/aic7xxx/aic79xx_core.:ahd_set_tags() static
Date: Wed, 28 Jun 2006 18:54:42 +0200
Message-ID: <20060628165442.GP13915@stusta.de>
References: <20060627015211.ce480da6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751429AbWF1RAG@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060627015211.ce480da6.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 27, 2006 at 01:52:11AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-mm2:
>...
>  git-scsi-misc.patch
>...
>  git trees.
>...

ahd_set_tags() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/aic7xxx/aic79xx.h      |    5 -----
 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.17-mm3-full/drivers/scsi/aic7xxx/aic79xx.h.old	2006-06-27 17:46:00.000000000 +0200
+++ linux-2.6.17-mm3-full/drivers/scsi/aic7xxx/aic79xx.h	2006-06-27 17:46:08.000000000 +0200
@@ -1427,11 +1427,6 @@
 	AHD_QUEUE_TAGGED
 } ahd_queue_alg;
 
-void			ahd_set_tags(struct ahd_softc *ahd,
-				     struct scsi_cmnd *cmd,
-				     struct ahd_devinfo *devinfo,
-				     ahd_queue_alg alg);
-
 /**************************** Target Mode *************************************/
 #ifdef AHD_TARGET_MODE
 void		ahd_send_lstate_events(struct ahd_softc *,
--- linux-2.6.17-mm3-full/drivers/scsi/aic7xxx/aic79xx_core.c.old	2006-06-27 17:46:17.000000000 +0200
+++ linux-2.6.17-mm3-full/drivers/scsi/aic7xxx/aic79xx_core.c	2006-06-27 17:46:27.000000000 +0200
@@ -3877,7 +3877,7 @@
 /*
  * Update the current state of tagged queuing for a given target.
  */
-void
+static void
 ahd_set_tags(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
 	     struct ahd_devinfo *devinfo, ahd_queue_alg alg)
 {
