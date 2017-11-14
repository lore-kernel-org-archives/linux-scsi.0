From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate device
Date: Tue, 14 Nov 2017 15:00:17 +0100
Message-ID: <20171114140017.17782-1-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Just like all previous UAS capable Seagate disk enclosures, this
one needs a US_FL_NO_ATA_1X quirk.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
Reported-by: Wido <wido.gg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2fe4fd336446..a1ddcbfb7323 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -114,6 +114,13 @@ UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Wido <wido.gg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> */
+UNUSUAL_DEV(0x0bc2, 0xab24, 0x0000, 0x9999,
+		"Seagate",
+		"BUP Slim BK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: G. Richard Bellamy <rbellamy-1/AleqyZJC8ybS5Ee8rs3A@public.gmane.org> */
 UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
 		"Seagate",
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
