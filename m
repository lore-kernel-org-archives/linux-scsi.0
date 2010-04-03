From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Sat, 3 Apr 2010 12:42:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004031241270.18796-100000@netrider.rowland.org>
References: <4BB76178.70008@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BB76178.70008@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On Sat, 3 Apr 2010, Jonas Schwertfeger wrote:

> On 04/03/2010 03:12 PM, Mark Lord wrote:
>  > Here's the pre-release, attached to this email.
>  > Please do give it a try and report back.
> 
> Doesn't seem to fix it. Here's the output:
> 
> sudo ./hdparm --verbose /dev/sdb
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

Can you acquire a usbmon trace showing what happens when you run this?  
Instructions are in the kernel source file 
Documentation/usb/usbmon.txt.

Alan Stern

