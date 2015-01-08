From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures
Date: Thu,  8 Jan 2015 15:15:15 +0100
Message-ID: <1420726515-13606-2-git-send-email-hdegoede@redhat.com>
References: <1420726515-13606-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1420726515-13606-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Just like all previous UAS capable Seagate disk enclosures, these need the
US_FL_NO_ATA_1X to not crash when udev probes them.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index f8492c1..9ec4561 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -75,6 +75,13 @@ UNUSUAL_DEV(0x0bc2, 0xa013, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x0bc2, 0xa0a4, 0x0000, 0x9999,
+		"Seagate",
+		"Backup Plus Desk",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* https://bbs.archlinux.org/viewtopic.php?id=183190 */
 UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		"Seagate",
@@ -89,6 +96,13 @@ UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: G. Richard Bellamy <rbellamy@pteradigm.com> */
+UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
+		"Seagate",
+		"BUP Fast HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
 UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMicron",
-- 
2.1.0
