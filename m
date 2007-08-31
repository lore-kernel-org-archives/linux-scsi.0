From: Andreas Koenecke <akoenecke@akoenecke.de>
Subject: Re: usb-storage and Motorola Z6
Date: Fri, 31 Aug 2007 21:04:05 +0200
Message-ID: <20070831190405.GA7506@kocom.akoenecke.de>
References: <20070828215215.GB20127@kocom.akoenecke.de>
	<Pine.LNX.4.44L0.0708291005300.2554-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708291005300.2554-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: USB users list <linux-usb-users@lists.sourceforge.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

* Mittwoch, 29. August 2007 um 10:07 (-0400) schrieb Alan Stern:
> 
> You can edit the source code of the SCSI core to make it ignore the PQ 
> value.  In the file drivers/scsi/scsi_sysfs.c, find the 
> scsi_bus_match() routine and change the last line from:
> 
> 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
> 
> to
> 
> 	return 1;

OK, I have done it. But there ist still no success.
When I connect the phone the messages are:
--------------------------------------------------------------------------------------------
Aug 31 20:14:53 kocom kernel: usb 3-1: new high speed USB device using ehci_hcd and address 2
Aug 31 20:14:53 kocom kernel: usb 3-1: configuration #1 chosen from 1 choice
Aug 31 20:14:53 kocom kernel: usbcore: registered new interface driver libusual
Aug 31 20:14:53 kocom kernel: Initializing USB Mass Storage driver...
Aug 31 20:14:53 kocom kernel: scsi3 : SCSI emulation for USB Mass Storage devices
Aug 31 20:14:53 kocom kernel: usb-storage: device found at 2
Aug 31 20:14:53 kocom kernel: usb-storage: waiting for device to settle before scanning
Aug 31 20:14:53 kocom kernel: usbcore: registered new interface driver usb-storage
Aug 31 20:14:53 kocom kernel: USB Mass Storage support registered.
Aug 31 20:14:58 kocom kernel: usb-storage: device scan complete
Aug 31 20:14:58 kocom kernel: scsi 3:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
Aug 31 20:14:58 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:14:58 kocom kernel: scsi 3:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
Aug 31 20:14:58 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:14:58 kocom kernel: sd 3:0:0:0: [sdb] Attached SCSI removable disk
Aug 31 20:14:58 kocom kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:14:59 kocom kernel: sd 3:0:0:1: [sdc] Attached SCSI removable disk
Aug 31 20:14:59 kocom kernel: sd 3:0:0:1: Attached scsi generic sg3 type 0
Aug 31 20:14:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:01 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:02 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:02 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:02 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:02 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:03 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:03 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:03 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:07 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:07 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:08 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:08 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:08 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:08 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:09 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:11 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:13 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:15:13 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 2
Aug 31 20:17:06 kocom kernel: usb 3-1: USB disconnect, address 2
------------------------------------------------------------------------------------------------------------

/proc/partition and 'fdisk' show no sdb or sdc.
You can download the messages with debug-Output from
<http://www.akoenecke.de/moto/usb_debug.txt>

Andreas


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
