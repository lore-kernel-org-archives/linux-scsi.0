From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model
Date: Fri, 31 Oct 2014 14:37:32 +0100
Message-ID: <1414762652-3586-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org.#.3.16
List-Id: linux-scsi@vger.kernel.org

These drives hang when receiving ATA12 commands, so set the US_FL_NO_ATA_1X
quirk to filter these out.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 44ab3289..2fefaf9 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -75,6 +75,13 @@ UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
+UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
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
