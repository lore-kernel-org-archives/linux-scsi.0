From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Remove US_FL_NO_ATA_1X unusual device entries for Seagate devices
Date: Wed, 29 Nov 2017 10:16:17 +0100
Message-ID: <20171129091617.5183-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753908AbdK2JQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 04:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Since commit 7fee72d5e8f1 ("uas: Always apply US_FL_NO_ATA_1X quirk to
Seagate devices"), the US_FL_NO_ATA_1X is always set for Seagate devices,
so the per device unusual_uas.h entries for Seagate devices can be
removed.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 63 ---------------------------------------
 1 file changed, 63 deletions(-)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index d520374a824e..bf457b0f6a1f 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -38,20 +38,6 @@ UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_UAS),
 
-/* https://bugzilla.kernel.org/show_bug.cgi?id=79511 */
-UNUSUAL_DEV(0x0bc2, 0x2312, 0x0000, 0x9999,
-		"Seagate",
-		"Expansion Desk",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
-UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x9999,
-		"Seagate",
-		"Expansion Desk",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
 /* Reported-by: David Webb <djw@noc.ac.uk> */
 UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		"Seagate",
@@ -59,55 +45,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
-/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
-UNUSUAL_DEV(0x0bc2, 0x3320, 0x0000, 0x9999,
-		"Seagate",
-		"Expansion Desk",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* Reported-by: Bogdan Mihalcea <bogdan.mihalcea@infim.ro> */
-UNUSUAL_DEV(0x0bc2, 0xa003, 0x0000, 0x9999,
-		"Seagate",
-		"Backup Plus",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* Reported-by: Marcin Zajączkowski <mszpak@wp.pl> */
-UNUSUAL_DEV(0x0bc2, 0xa013, 0x0000, 0x9999,
-		"Seagate",
-		"Backup Plus",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
-UNUSUAL_DEV(0x0bc2, 0xa0a4, 0x0000, 0x9999,
-		"Seagate",
-		"Backup Plus Desk",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
-UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
-		"Seagate",
-		"Backup+ BK",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
-UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
-		"Seagate",
-		"Backup+ BK",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
-/* Reported-by: G. Richard Bellamy <rbellamy@pteradigm.com> */
-UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
-		"Seagate",
-		"BUP Fast HDD",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_ATA_1X),
-
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
-- 
2.14.3
