From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/scsi_scan.c: make 2 functions static
Date: Mon, 20 Nov 2006 03:23:52 +0100
Message-ID: <20061120022352.GH31879@stusta.de>
References: <20061114014125.dd315fff.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39953 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S933868AbWKTCXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 21:23:53 -0500
Content-Disposition: inline
In-Reply-To: <20061114014125.dd315fff.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Nov 14, 2006 at 01:41:25AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.19-rc5-mm2:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/scsi_scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19-rc5-mm2/drivers/scsi/scsi_scan.c.old	2006-11-20 00:57:44.000000000 +0100
+++ linux-2.6.19-rc5-mm2/drivers/scsi/scsi_scan.c	2006-11-20 00:58:05.000000000 +0100
@@ -1633,7 +1633,7 @@
  * that other asynchronous scans started after this one won't affect the
  * ordering of the discovered devices.
  */
-struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
+static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
 
@@ -1677,7 +1677,7 @@
  * This function announces all the devices it has found to the rest
  * of the system.
  */
-void scsi_finish_async_scan(struct async_scan_data *data)
+static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
 

