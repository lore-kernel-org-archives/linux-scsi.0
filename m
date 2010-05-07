From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 7 May 2010 11:03:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005071055200.1804-100000@iolanthe.rowland.org>
References: <4BE3EE87.6020505@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE3EE87.6020505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 May 2010, Jonas Schwertfeger wrote:

> On 04/29/2010 05:45 PM, Alan Stern wrote:
>  > I would still like to see a usbmon trace of hdparm under USB-2.
> 
> hdparm through USB-2:
> 
> /dev/sdb:
> outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
> data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> SG_IO: ATA_16 status=0x0, host_status=0x0, driver_status=0x0
> SG_IO: bad response (not CHECK_CONDITION)
> Trying legacy HDIO_DRIVE_CMD
> outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
> data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
> SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
> SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00 00 
> 00 40 51 00 00 00 00 00 00 00 00 00 00
> SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
>        ATA_16 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
> I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
>   HDIO_DRIVE_CMD(identify) failed: Input/output error
>   readonly      =  0 (off)
>   readahead     = 256 (on)
>   geometry      = 121601/255/63, sectors = 1953525168, start = 0
> 
> ffff8801f8199540 602153163 S Bo:1:003:2 -115 31 = 55534243 d4000000 
> 00020000 80001085 082e0000 00010000 00000000 40ec00
> ffff8801f8199540 602153314 C Bo:1:003:2 0 31 >
> ffff8801f8184d80 602153376 S Bi:1:003:1 -115 512 <
> ffff8801f8184d80 602159046 C Bi:1:003:1 0 512 = 00000000 00000000 
> 00000000 00000000 00000000 00000000 00000000 00000000
> ffff8801f8199540 602159103 S Bi:1:003:1 -115 13 <
> ffff8801f8199540 602159156 C Bi:1:003:1 0 13 = 55534253 d4000000 00000000 00
> ffff8801f8199540 602159382 S Bo:1:003:2 -115 31 = 55534243 d5000000 
> 00020000 80001085 082e0000 00010000 00000000 40a100
> ffff8801f8199540 602159536 C Bo:1:003:2 0 31 >
> ffff8801f8184d80 602159594 S Bi:1:003:1 -115 512 <
> ffff8801f8184d80 602159791 C Bi:1:003:1 -32 0
> ffff8801f8199540 602159846 S Co:1:003:0 s 02 01 0000 0081 0000 0
> ffff8801f8199540 602159900 C Co:1:003:0 0 0
> ffff8801f8199540 602159951 S Bi:1:003:1 -115 13 <
> ffff8801f8199540 602160029 C Bi:1:003:1 0 13 = 55534253 d5000000 00020000 01
> ffff8801f8199540 602160100 S Bo:1:003:2 -115 31 = 55534243 d6000000 
> 60000000 80000603 00000060 00000000 00000000 000000
> ffff8801f8199540 602160159 C Bo:1:003:2 0 31 >
> ffff8801f8184d80 602160201 S Bi:1:003:1 -115 96 <
> ffff8801f8184d80 602160276 C Bi:1:003:1 0 96 = 00000000 00000000 
> 00000000 00000000 00000000 00000000 00000000 00000000
> ffff8801f8199540 602160334 S Bi:1:003:1 -115 13 <
> ffff8801f8199540 602160418 C Bi:1:003:1 0 13 = 55534253 d6000000 00000000 00
> ffff8801f8199540 602161915 S Bo:1:003:2 -115 31 = 55534243 d7000000 
> 00100000 80000a28 00000000 00000008 00000000 000000
> ffff8801f8199540 602162023 C Bo:1:003:2 0 31 >
> ffff8801f8184d80 602162080 S Bi:1:003:1 -115 4096 <
> ffff8801f8184d80 602162284 C Bi:1:003:1 0 4096 = 00000000 00000000 
> 00000000 00000000 00000000 00000000 00000000 00000000
> ffff8801f8199540 602162344 S Bi:1:003:1 -115 13 <
> ffff8801f8199540 602162405 C Bi:1:003:1 0 13 = 55534253 d7000000 00000000 00

Hmm.  I'm not sure I believe this data.  For a while (starting with
2.6.33) the usbmon implementation didn't work right with EHCI -- it
looked in the transfer buffer before the DMA-unmapping was done, so on
a system with >= 4 GB of memory it wouldn't always see the data.  The
fix for this was merged only within the last week or so.

Can you repeat the USB-2.0 test but this time doing "rmmod ehci-hcd" 
beforehand?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
