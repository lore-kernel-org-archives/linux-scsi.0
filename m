From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17] uas: Add another ASM1051 usb-id to the uas blacklist
Date: Tue, 23 Sep 2014 15:48:50 +0200
Message-ID: <1411480130-14260-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbaIWNs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2014 09:48:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

As most ASM1051 based devices, this one has unfixable issues with uas too.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 94fb09f..8511b54 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -67,3 +67,11 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMS567",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES),
+
+/* Most ASM1051 based devices have issues with uas, blacklist them all */
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x174c, 0x5106, 0x0000, 0x9999,
+		"ASMedia",
+		"ASM1051",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
-- 
2.1.0

