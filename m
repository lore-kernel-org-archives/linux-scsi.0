From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 7 Apr 2010 15:18:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004071516260.5760-100000@iolanthe.rowland.org>
References: <4BBCCA0D.3000708@teksavvy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33320 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751289Ab0DGTSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2010 15:18:30 -0400
In-Reply-To: <4BBCCA0D.3000708@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Sergei Shtylyov <sshtylyov@mvista.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Mark Lord <liml@rtr.ca>

On Wed, 7 Apr 2010, Mark Lord wrote:

> Errr.. yes and no.
> 
> Yes, because nobody else is likely to do anything about it,
> so I will work around the hardware bug by updating hdparm.
> 
> But no, there's no funky missing data length issue there.
> Just a bridge chip that doesn't understand ATA_16 commands.

Did you look at this comment and the following one:

https://bugs.launchpad.net/ubuntu/+source/linux-fsl-imx51/+bug/431963#25

Is the engineer from Genesys Logic totally off-base?

Alan Stern

