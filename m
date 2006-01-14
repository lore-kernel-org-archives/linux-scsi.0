From: andrew.vasquez@qlogic.com
Subject: [PATCH 13/15] qla2xxx: Kconfig update: Add URL to download firmware images.
Date: Fri, 13 Jan 2006 17:05:53 -0800
Message-ID: <11372007482523-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56613 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945938AbWANBFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:54 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

a858c4426a247ba3bf7e28600c8488d6ec0ab283
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 02cc794..5758b25 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -22,6 +22,10 @@ config SCSI_QLA_FC
 	Upon request, the driver caches the firmware image until
 	the driver is unloaded.
 
+	Firmware images can be retrieved from:
+
+		ftp://ftp.qlogic.com/outgoing/linux/firmware/
+
 	NOTE: The original method of building firmware-loader
 	modules has been deprecated as the firmware-images will
 	be removed from the kernel sources.
-- 
1.1.1-g4c34


