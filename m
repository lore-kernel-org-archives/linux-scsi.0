From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17] uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives
Date: Wed, 17 Sep 2014 10:10:58 +0200
Message-ID: <1410941458-5049-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

https://bbs.archlinux.org/viewtopic.php?pid=1457492

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 3e62437..94fb09f 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -54,6 +54,13 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
+UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
+		"Seagate",
+		"Backup+ BK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
 UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMicron",
-- 
2.1.0
