From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS539
Date: Mon, 23 Feb 2015 13:41:14 +0100
Message-ID: <1424695274-14007-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbbBWMlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 07:41:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Tom Arild Naess <tanaess@gmail.com>, Hans de Goede <hdegoede@redhat.com>

Like the JMicron JMS567 enclosures with the JMS539 choke on report-opcodes,
so avoid it.

Tested-and-reported-by: Tom Arild Naess <tanaess@gmail.com>
Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index dbc00e5..8257042 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -113,6 +113,13 @@ UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Tom Arild Naess <tanaess@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0539, 0x0000, 0x9999,
+		"JMicron",
+		"JMS539",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
 UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMicron",
-- 
2.3.0

