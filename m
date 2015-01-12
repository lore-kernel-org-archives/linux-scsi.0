From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add no-report-opcodes quirk for Simpletech devices with id 4971:8017
Date: Mon, 12 Jan 2015 13:34:33 +0100
Message-ID: <1421066073-17561-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Like some other uas devices these devices hang when a report-opcodes scsi
command is send to them.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1124119
Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 9ec4561..da3d98c 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -130,3 +130,10 @@ UNUSUAL_DEV(0x4971, 0x1012, 0x0000, 0x9999,
 		"External HDD",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
+
+/* Reported-by: Richard Henderson <rth@redhat.com> */
+UNUSUAL_DEV(0x4971, 0x8017, 0x0000, 0x9999,
+		"SimpleTech",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
-- 
2.1.0
