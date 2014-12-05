From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
Date: Fri,  5 Dec 2014 11:11:29 +0100
Message-ID: <1417774289-15025-2-git-send-email-hdegoede@redhat.com>
References: <1417774289-15025-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbaLEKLg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 05:11:36 -0500
In-Reply-To: <1417774289-15025-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathias Nyman <mathias.nyman@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Marcin=20Zaj=C4=85czkowski?= <mszpak@wp.pl>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

This is yet another Seagate device which needs the US_FL_NO_ATA_1X quir=
k

Reported-by: Marcin Zaj=C4=85czkowski <mszpak@wp.pl>
Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/un=
usual_uas.h
index 18a283d..2918376 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -68,6 +68,13 @@ UNUSUAL_DEV(0x0bc2, 0xa003, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
=20
+/* Reported-by: Marcin Zaj=C4=85czkowski <mszpak@wp.pl> */
+UNUSUAL_DEV(0x0bc2, 0xa013, 0x0000, 0x9999,
+		"Seagate",
+		"Backup Plus",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* https://bbs.archlinux.org/viewtopic.php?id=3D183190 */
 UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		"Seagate",
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
