From: Andi Kleen <andi@firstfloor.org>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 9 Jan 2008 23:23:08 +0100
Message-ID: <20080109222308.GE15612@one.firstfloor.org>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org> <47853FA7.9050506@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:40035 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYAIWUf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 17:20:35 -0500
Content-Disposition: inline
In-Reply-To: <47853FA7.9050506@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Jon Watte <jwatte@gmail.com>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Jan 09, 2008 at 10:41:59PM +0100, Stefan Richter wrote:
> Matthew Wilcox wrote:
> > OK, how about this?
> > 
> > config BLK_DEV_ATA_SD
> > 	tristate "ATA disc support"
> > 	select BLK_DEV_SD
> > 
> > config BLK_DEV_ATA_SR
> > 	tristate "ATA CDROM support"
> > 	select BLK_DEV_SR
> 
> It's probably OK for many uses.
> 
> However, this further obfuscates the fact that libata uses Linux' SCSI
> midlayer and highlevel.  Which is a bad thing.  For example, there are

People are not interested in how libata is implemented internally.
They just want their SATA interfaces to work.

Kconfig is also not an educational facility or high level
design description of the code, but a pragmatic tool to get the job
done.

> further configuration options in the SCSI menu which influence the SCSI
> midlayer and highlevel, and therefore influence the software stack which
> drives the ATA disks and ATA CD-ROMs.  Hence this change does not make
> the configuration menu more logical.

I think Matthew's patch with appropiate help texts is a good idea.

-Andi
