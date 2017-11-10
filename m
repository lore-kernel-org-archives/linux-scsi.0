From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate device
Date: Fri, 10 Nov 2017 16:13:44 +0100
Message-ID: <20171110151344.10563-1-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Andrey Astafyev <1@246060.ru>
List-Id: linux-scsi@vger.kernel.org

Just like all previous UAS capable Seagate disk enclosures, this
one needs a US_FL_NO_ATA_1X quirk.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Andrey Astafyev <1@246060.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index cde115359793..2fe4fd336446 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -121,6 +121,13 @@ UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Andrey Astafyev <dev@246060.ru> */
+UNUSUAL_DEV(0x0bc2, 0xab30, 0x0000, 0x9999,
+		"Seagate",
+		"BUP BK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
-- 
2.14.3
