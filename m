From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 11:29:26 -0600
Message-ID: <1199899766.3493.20.camel@localhost.localdomain>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com>
	 <p738x2zosmd.fsf@bingen.suse.de>
	 <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53242 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYAIR33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 12:29:29 -0500
In-Reply-To: <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Watte <jwatte@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org


On Wed, 2008-01-09 at 09:21 -0800, Jon Watte wrote:
> Yes, that turns out to be the case. Thanks for the quick sanity check!
> I wonder if it's possible to magically turn that on when selecting
> AHCI support in menuconfig? That way, it'd be harder for someone else
> to make the same mistake.

We've had several discussions on this.  However, AHCI is used in a lot
of systems for CD-ROM support only.  The resolution last time was to add
this to the help text for ATA:

	  If you want to use a ATA hard disk, ATA tape drive, ATA CD-ROM or
	  any other ATA device under Linux, say Y and make sure that you know
	  the name of your ATA host adapter (the card inside your computer
	  that "speaks" the ATA protocol, also called ATA controller),
	  because you will be asked for it.

	  NOTE: ATA enables basic SCSI support; *however*,
	  'SCSI disk support', 'SCSI tape support', or
	  'SCSI CDROM support' may also be needed,
	  depending on your hardware configuration.

The bottom line is that working out how to configure your own kernel is
really hard (even I haven't done it from scratch for ages ... I usually
steal a distro config as the basis for my choices).

> On Jan 9, 2008 8:45 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > "Jon Watte" <jwatte@gmail.com> writes:
> > >
> > > Any help or pointers to self-help would be appreciated!
> >
> > The usual mistake is to not enable CONFIG_BLK_DEV_SD
> >
> > -Andi

James


