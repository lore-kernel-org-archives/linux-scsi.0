From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver (draft)
Date: Fri, 18 Jan 2008 11:58:44 -0600
Message-ID: <1200679124.3111.28.camel@localhost.localdomain>
References: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com>
	 <4785C48C.50705@garzik.org>  <4785C764.3070407@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4785C764.3070407@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Thu, 2008-01-10 at 02:21 -0500, Jeff Garzik wrote:
> Jeff Garzik wrote:
> > 1) To make it easier for people to review and test the driver, I would 
> > suggest posting a diff against 2.6.24-rc7 (or 2.6.23), ignoring my 
> > original code.  Thus, it would result in a patch
> 
> Er, that sentence was incomplete.  Continuing...
> 
> 
> Thus it would result in a patch that adds a new file 
> drivers/scsi/mvsas.c to the 2.6.24-rc7 kernel, and modifies 
> drivers/scsi/Makefile and drivers/scsi/Kconfig to enable this new driver.
> 
> That is the format that developers and users are most familiar with, 
> when reviewing (and testing) a new driver.
> 
> But of course this is a draft, so these guidelines are certainly loose...

OK, in order to try to expedite this, I've created a mvsas branch in

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

I think the first patch (the infrastructure change) is safe to go in
immediately.  Unfortunately, I can't put the marvell update in because
the emailed patch is corrupt (it looks like the mailer has added line
breaks).

Ke, If you can't get your email tool to insert plain text (as a lot of
microsoft based one's can't), you can add the patch as an attachment; I
can apply it from that (Although in line plain text is by far the
preferred method for review if you can do it, we have a bunch of other
driver writers who have problematic email tools, so we're reasonably
used to this).

Thanks,

James


