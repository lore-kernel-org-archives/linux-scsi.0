From: James.Smart@Emulex.Com
Subject: [PATCH 5/15]  lpfc 8.1.0 : Fix comments for nodev_tmo
Date: Fri, 28 Oct 2005 20:29:21 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A54@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:977 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750916AbVJ2A3X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:23 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TMDp018514
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:23 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix comments for nodev_tmo


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -441,7 +441,7 @@ LPFC_ATTR_R(scan_down, 1, 0, 1,
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
-# until the timer expires. Value range is [0,255]. Default value is 20.
+# until the timer expires. Value range is [0,255]. Default value is 30.
 # NOTE: this MUST be less then the SCSI Layer command timeout - 1.
 */
 LPFC_ATTR_RW(nodev_tmo, 30, 0, 255,
