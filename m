From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Fri, 12 Sep 2003 16:03:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309121559521.2323-100000@ida.rowland.org>
References: <200309120447.NAA04636@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7684 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261833AbTILUDA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 16:03:00 -0400
In-Reply-To: <200309120447.NAA04636@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Fri, 12 Sep 2003, Tomita, Haruo wrote:

> hub.c: port 1, portstatus 110, change 3, 12 Mb/s
> hub.c: port 1 connection change
> hub.c: port 1, portstatus 110, change 3, 12 Mb/s
> usb.c: USB disconnect on device 00:07.2-1 address 2
> usb-storage: storage_disconnect() called
> usb-storage: -- releasing irq URB
> usb-storage: USB IRQ received for device on host 1
> usb-storage: -- IRQ data length is 2
> usb-storage: -- IRQ state is -2
> usb-storage: -- Interrupt Status (0x0, 0x0)
> usb-storage: ERROR: Unwanted interrupt received!
> usb-storage: -- usb_unlink_urb() returned 0
> usb-storage: -- releasing main URB
> usb-storage: -- usb_unlink_urb() returned -19
> usb.c: kusbd: /sbin/hotplug remove 2
> hub.c: port 1, portstatus 103, change 0, 12 Mb/s
> usb.c: ignoring set_interface for dev 2, iface 0, alt 0
> hub.c: port 2, portstatus 100, change 0, 12 Mb/s
> hub.c: port 1, portstatus 103, change 0, 12 Mb/s
> hub.c: port 2, portstatus 100, change 0, 12 Mb/s

This makes it look like the device isn't probed again after usbdevfs does 
the port reset.  Yet another thing to worry about.  But since it's in 2.4, 
people probably won't worry about it very hard.

Alan Stern

