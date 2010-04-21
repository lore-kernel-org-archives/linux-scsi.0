From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 15:07:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004211506040.1422-100000@iolanthe.rowland.org>
References: <4BCF4394.3080701@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BCF4394.3080701@gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2010, Jonas Schwertfeger wrote:

> On 04/21/2010 08:17 PM, Mark Lord wrote:
> 
>  > Let's try again. Does the attached copy of hdparm work for everybody
>  > now? It uses ATA_16 by default, for everything.
> 
> No, it doesn't:
> 
> /dev/sdb:
> outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
> data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

That line is supposed to be the data returned by the drive?  It sure 
doesn't look right.

Jonas, can you run the same test, but this time with the drive attached 
to your EHCI controller, and get a usbmon log?

Alan Stern

