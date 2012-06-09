From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2 3/4] usb: storage: update usb devices for write cache quirk in quirk list.
Date: Fri,  8 Jun 2012 23:12:20 -0400
Message-ID: <1339211540-10315-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Update information of Segate Portable HDD and WD My Passport HDD in
quirk list.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1719886..1d895f4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2025,6 +2025,16 @@ UNUSUAL_DEV( 0xed10, 0x7636, 0x0001, 0x0001,
 		"Digital MP3 Audio Player",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE ),
 
+UNUSUAL_DEV(0x1058, 0x070A, 0x0000, 0x9999,
+		"Westron Digital",
+		"My Passport HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
+
+UNUSUAL_DEV(0x0BC2, 0x2300, 0x0000, 0x9999,
+		"Seagate",
+		"Portable HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
+
 /* Control/Bulk transport for all SubClass values */
 USUAL_DEV(USB_SC_RBC, USB_PR_CB, USB_US_TYPE_STOR),
 USUAL_DEV(USB_SC_8020, USB_PR_CB, USB_US_TYPE_STOR),
-- 
1.7.9.5
