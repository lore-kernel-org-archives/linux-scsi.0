From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 13:44:38 -0500
Message-ID: <1217357078.6103.51.camel@localhost.localdomain>
References: <488F524F.6020905@redhat.com>
	 <20080729182611.GB24924@parisc-linux.org>
	 <1217356645.6103.48.camel@localhost.localdomain>
	 <20080729184243.GC24924@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55679 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbYG2SpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 14:45:07 -0400
In-Reply-To: <20080729184243.GC24924@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>

On Tue, 2008-07-29 at 12:42 -0600, Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 01:37:25PM -0500, James Bottomley wrote:
> > scsi_debug does exactly the same thing, so it reports anything you tell
> > it (Martin Petersen actually added this so he could test with 4k
> > sectors).
> > 
> > The problem, which ata_ram also suffers, is that the tools we most need
> > to test are the ones for manipulating non volatile characteristics (like
> > partition tables).  We'd really like the disk contents to survive reboot
> > for this ...
> 
> Ummm... _reboot_, or _module unload/reload_?  I could certainly include
> an option to populate the ramdisc from a file.  Is the ioctl to re-read
> the partition table not enough?

reboot ... we'd like to take the tools through shutdown restart testing
to make sure they're all working ... of course, then there's the
bios ...

James


