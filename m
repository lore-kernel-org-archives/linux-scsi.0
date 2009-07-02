From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re: [PATCH] cciss: Ignore stale commands after reboot
Date: Thu, 2 Jul 2009 22:01:04 +0200
Message-ID: <20090702200104.GF23611@kernel.dk>
References: <20090702125030.d9967a7f.akpm@linux-foundation.org> <0F5B06BAB751E047AB5C87D1F77A77886948B9516C@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53477 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbZGBUBC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jul 2009 16:01:02 -0400
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77886948B9516C@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Jul 02 2009, Miller, Mike (OS Dev) wrote:
>  
> 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > Sent: Thursday, July 02, 2009 2:51 PM
> > To: Miller, Mike (OS Dev)
> > Subject: Fw: Re: [PATCH] cciss: Ignore stale commands after reboot
> > 
> > 
> > oh, Jens already did it.
> > 
> > Begin forwarded message:
> > 
> > Date: Thu, 2 Jul 2009 21:00:49 +0200
> > From: Jens Axboe <jens.axboe@oracle.com>
> > To: Hannes Reinecke <hare@suse.de>
> > Cc: scameron@beardog.cca.cpqcorp.net, 
> > linux-kernel@vger.kernel.org, mikem@beardog.cca.cpqcorp.net
> > Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
> > 
> > 
> > On Thu, Jul 02 2009, Hannes Reinecke wrote:
> > > 
> > > When doing an unexpected shutdown like kexec the cciss 
> > firmware might 
> > > still have some commands in flight, which it is trying to complete.
> > > The driver is doing it's best on resetting the HBA, but 
> > sadly there's 
> > > a firmware issue causing the firmware _not_ to abort or drop old 
> > > commands.
> > > So the firmware will send us commands which we haven't 
> > accounted for, 
> > > causing the driver to panic.
> > > 
> > > With this patch we're just ignoring these commands as there 
> > is nothing 
> > > we could be doing with them anyway.
> > 
> > Looks good to me. Mike, Stephen?
> 
> Sorry I haven't seen this before. The beardog addresses are no longer
> valid. We moved into a dungeon and into a new domain. The good folks
> in IT have yet to assign another IP address/domain name or an MX
> record for the mail servers. I hope that by next week that will be
> corrected. Until then all Steve and I have to use is some form of
> OutHouse mail client.
>
> Acked-by: Mike Miller <mike.miller@hp.com>

OK, I'll add the patch with your ack.

-- 
Jens Axboe

