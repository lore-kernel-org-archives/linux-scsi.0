From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 3/3] usb: core: update usb devices for write cache quirk in quirk list.
Date: Wed,  6 Jun 2012 08:21:09 -0400
Message-ID: <1338985269-9756-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Update Product ID and Vendor ID of Segate Portable HDD and WD My Passport HDD in quirk list.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 drivers/usb/core/quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 32d3adc..624d111 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -153,6 +153,12 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Seagate Portable Hdd */
+	{ USB_DEVICE(0x0BC2, 0x2300), .driver_info = USB_QUIRK_WRITE_CACHE },
+
+	/* My Passport Hdd (WD) */
+	{ USB_DEVICE(0x1058, 0x070A), .driver_info = USB_QUIRK_WRITE_CACHE },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
1.7.9.5
