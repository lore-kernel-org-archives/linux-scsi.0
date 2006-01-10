From: <gregkh@suse.de>
Subject: patch add-pseudo-lld-bus_type-probe-and-remove-methods.patch added to gregkh-2.6 tree
Date: Mon, 09 Jan 2006 22:00:08 -0800
Message-ID: <1EwCYC-2YB-00@press.kroah.org>
References: <20060105142951.13.29@flint.arm.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:25274 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S1750832AbWAJGAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 01:00:49 -0500
In-Reply-To: <20060105142951.13.29@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rmk@arm.linux.org.uk, greg@kroah.com, gregkh@suse.de, linux-scsi@vger.kernel.org, rmk+kernel@arm.linux.org.uk


This is a note to let you know that I've just added the patch titled

     Subject: [CFT 29/29] Add Pseudo LLD bus_type probe and remove methods

to my gregkh-2.6 tree.  Its filename is

     add-pseudo-lld-bus_type-probe-and-remove-methods.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rmk+greg=kroah.com@arm.linux.org.uk Thu Jan  5 06:49:11 2006
From: Russell King <rmk@arm.linux.org.uk>
CC: Greg K-H <greg@kroah.com>, SCSI <linux-scsi@vger.kernel.org>
Subject: [CFT 29/29] Add Pseudo LLD bus_type probe and remove methods
Date: Thu, 05 Jan 2006 14:44:46 +0000
Message-ID: <20060105142951.13.29@flint.arm.linux.org.uk>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- gregkh-2.6.orig/drivers/scsi/scsi_debug.c
+++ gregkh-2.6/drivers/scsi/scsi_debug.c
@@ -221,8 +221,6 @@ static struct bus_type pseudo_lld_bus;
 static struct device_driver sdebug_driverfs_driver = {
 	.name 		= sdebug_proc_name,
 	.bus		= &pseudo_lld_bus,
-	.probe          = sdebug_driver_probe,
-	.remove         = sdebug_driver_remove,
 };
 
 static const int check_condition_result =
@@ -1796,6 +1794,8 @@ static int pseudo_lld_bus_match(struct d
 static struct bus_type pseudo_lld_bus = {
         .name = "pseudo",
         .match = pseudo_lld_bus_match,
+	.probe = sdebug_driver_probe,
+	.remove = sdebug_driver_remove,
 };
 
 static void sdebug_release_adapter(struct device * dev)


Patches currently in gregkh-2.6 which might be from rmk@arm.linux.org.uk are

driver/add-bttv-sub-bus_type-probe-and-remove-methods.patch
driver/add-bus_type-probe-remove-shutdown-methods..patch
driver/add-ccwgroup_bus_type-probe-and-remove-methods.patch
driver/add-dio_bus_type-probe-and-remove-methods.patch
driver/add-ecard_bus_type-probe-remove-shutdown-methods.patch
driver/add-gameport-bus_type-probe-and-remove-methods.patch
driver/add-i2c_bus_type-probe-and-remove-methods.patch
driver/add-ide_bus_type-probe-and-remove-methods.patch
driver/add-locomo-bus_type-probe-remove-methods.patch
driver/add-logic-module-bus_type-probe-remove-methods.patch
driver/add-macio_bus_type-probe-and-remove-methods.patch
driver/add-mcp-bus_type-probe-and-remove-methods.patch
driver/add-mmc_bus_type-probe-and-remove-methods.patch
driver/add-ocp_bus_type-probe-and-remove-methods.patch
driver/add-of_platform_bus_type-probe-and-remove-methods.patch
driver/add-parisc_bus_type-probe-and-remove-methods.patch
driver/add-pci_bus_type-probe-and-remove-methods.patch
driver/add-pcmcia_bus_type-probe-and-remove-methods.patch
driver/add-pnp_bus_type-probe-and-remove-methods.patch
driver/add-pseudo-lld-bus_type-probe-and-remove-methods.patch
driver/add-rio_bus_type-probe-and-remove-methods.patch
driver/add-sa1111-bus_type-probe-remove-methods.patch
driver/add-serio-bus_type-probe-and-remove-methods.patch
driver/add-sh_bus_type-probe-and-remove-methods.patch
driver/add-superhyway_bus_type-probe-and-remove-methods.patch
driver/add-tiocx-bus_type-probe-remove-methods.patch
driver/add-usb_serial_bus_type-probe-and-remove-methods.patch
driver/add-vio_bus_type-probe-and-remove-methods.patch
driver/add-zorro_bus_type-probe-and-remove-methods.patch
driver/remove-usb-gadget-generic-driver-methods.patch
