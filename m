From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Wed, 22 Jan 2014 16:34:02 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401221632200.1310-100000@iolanthe.rowland.org>
References: <20140122220717.D61BDE5D@centrum.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140122220717.D61BDE5D-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?q?Milan_Svoboda?= <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?utf-8?q?USB_Storage_List?= <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 22 Jan 2014, Milan Svoboda wrote:

> >This continued a few more times until the computer gave up.  Maybe
> >there is something wrong with one particular block at that address on
> >the disk.
> 
> I tried to run fdisk /dev/sdb which obivously failed but it tried to access sectors 0, 1, 2, 3 which resulted in kernel log
> messages reporting invalid sectors.
> I tried to connect the disk with Windows and it was connected immediatelly, the partition is visible, I can read files, create files...
> No signs of problems visible...

Maybe Windows doesn't try to access that problematic disk block.

> I don't know if it tells anything, but Windows reports the disk as USB 2.0 SATA bridge even when connected to USB-3 ports.
> 
> >
> >Do you have a USB-2 port on the computer you can plug the disk into,
> >instead of USB-3?
> >
> 
> I tried it, but it is only one and separated on the other side of laptop so I could connect only one connector and the
> result is the same.

Which connector did you plug in: the data cable or the power cable?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
