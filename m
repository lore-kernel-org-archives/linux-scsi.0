From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 9 Apr 2010 15:25:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
References: <4BBF6B2F.9060902@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54521 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755608Ab0DITZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 15:25:32 -0400
In-Reply-To: <4BBF6B2F.9060902@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Fri, 9 Apr 2010, Jonas Schwertfeger wrote:

> On 04/09/2010 07:14 PM, Sarah Sharp wrote:
> > Someone should probably tell Neil Perng at Genesys Logic.  Maybe Dinh
> > Nguyen (from the launchpad entry) can provide an email address or
> > forward this thread on?
> 
> Why are we sure that my drive has a chip by Genesys Logic in it at all? 
>   I know that there are disks out there with that chip and that there 
> are issues with it, but how did we conclude that the Buffalo drive has 
> the same chip in it?  Is there a way for me to verify what chip is used 
> without opening the case?

Now that you mention it, we don't know what sort of chip you have.  
Only that the vendor ID is 0x0411 (MelCo., Inc.) and the product ID is 
0x0184.

I don't know of any way to find out what sort of chip it is without 
opening the case (except perhaps by asking the manufacturer).

Alan Stern

