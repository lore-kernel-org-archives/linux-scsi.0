From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] usb-storage and Motorola Z6
Date: Sat, 1 Sep 2007 11:30:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709011120340.6825-100000@netrider.rowland.org>
References: <20070901115626.GA21586@kocom.akoenecke.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3113 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752642AbXIAPdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Sep 2007 11:33:44 -0400
In-Reply-To: <20070901115626.GA21586@kocom.akoenecke.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Koenecke <akoenecke@akoenecke.de>
Cc: USB users list <linux-usb-users@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 1 Sep 2007, Andreas Koenecke wrote:

> I' done this, too.
> The non-debug-messages are now:
> ----------------------------------------------------------------------------
> Sep  1 13:09:17 kocom kernel: usb 3-1: new high speed USB device using ehci_hcd and address 12
> Sep  1 13:09:17 kocom kernel: usb 3-1: configuration #1 chosen from 1 choice
> Sep  1 13:09:17 kocom kernel: Initializing USB Mass Storage driver...
> Sep  1 13:09:17 kocom kernel: scsi7 : SCSI emulation for USB Mass Storage devices
> Sep  1 13:09:17 kocom kernel: usb-storage: device found at 12
> Sep  1 13:09:17 kocom kernel: usb-storage: waiting for device to settle before scanning
> Sep  1 13:09:17 kocom kernel: usbcore: registered new interface driver usb-storage
> Sep  1 13:09:17 kocom kernel: USB Mass Storage support registered.
> Sep  1 13:09:22 kocom kernel: usb-storage: device scan complete
> Sep  1 13:09:22 kocom kernel: scsi 7:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> Sep  1 13:09:22 kocom kernel: scsi 7:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
> Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: [sdb] Attached SCSI removable disk
> Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
> Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: [sdc] Attached SCSI removable disk
> Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: Attached scsi generic sg3 type 0
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
> Sep  1 13:09:28 kocom kernel:  sdb:
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
> Sep  1 13:09:28 kocom kernel:  sdc:
> Sep  1 13:09:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
> Sep  1 13:10:14 kocom kernel: usb 3-1: device descriptor read/64, error -110
> Sep  1 13:10:29 kocom kernel: usb 3-1: device descriptor read/64, error -110
> Sep  1 13:10:29 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
> Sep  1 13:10:44 kocom kernel: usb 3-1: device descriptor read/64, error -110
> Sep  1 13:11:00 kocom kernel: usb 3-1: device descriptor read/64, error -110
> Sep  1 13:11:00 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
> Sep  1 13:11:05 kocom kernel: usb 3-1: device descriptor read/8, error -110
> ------------------------------------------------------------------------------------------------
> 
> sdb and sdc appear in /proc/partitions, but trying to access with 'fdisk -l` or
> 'mount' freezes the phone.
> 
> I uploaded the debug-log to:
> <http://www.akoenecke.de/moto/usb_debug2.txt>
> 
> The debug-log included 2 spontaneous reboots and 1 freeze (in this order) of
> the phone without unplugging.

The resets and disconnects occurred because of yet another bug in the 
phone.  It reports that sdc has 128673 sectors, but in fact it probably 
has only 128672.  The error occurred when the computer tried to read 
the (non-existent) last sector.  The phone failed to follow the proper 
protocol for reporting an error, so the computer reset it.

It's not surprising; other devicees from Motorola have the same bug.  
The patch below ought to help.  However considering the number of other 
bugs and problems in this device, it's not clear how far you should try 
to push it...

Alan Stern


Index: usb-2.6/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
+++ usb-2.6/drivers/usb/storage/unusual_devs.h
@@ -1481,6 +1481,13 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by Andreas Koenecke <akoenecke@akoenecke.de> */
+UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
+		"Motorola",
+		"MSnc Z6",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
 UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
 		"MPIO",

