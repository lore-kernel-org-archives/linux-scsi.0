From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.29-rc5
Date: Fri, 20 Feb 2009 23:40:56 +0000
Message-ID: <1235173256.9025.47.camel@localhost.localdomain>
References: <1235170927.9025.42.camel@localhost.localdomain>
	 <20090220152305.8a2e384f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42161 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbZBTXk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 18:40:59 -0500
In-Reply-To: <20090220152305.8a2e384f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 15:23 -0800, Andrew Morton wrote:
> On Fri, 20 Feb 2009 17:02:07 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This is a bunch of assorted bug fixes (with several in the qlogic
> > drivers).
> > 
> > The patch is available at
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > Andrew Vasquez (3):
> >       qla2xxx: Update version number to 8.03.00-k3.
> >       qla2xxx: Mask out 'reserved' bits while processing FLT regions.
> >       qla2xxx: Properly acknowledge IDC notification messages.
> > 
> > Anirban Chakraborty (2):
> >       qla2xxx: Correct slab-error overwrite during vport creation and deletion.
> >       qla2xxx: Remove interrupt request bit check in the response processing pat
> > 
> > Brian King (3):
> >       ibmvfc: Increase cancel timeout
> >       ibmvfc: Fix rport relogin
> >       ibmvfc: Fix command timeout errors
> > 
> > James Smart (1):
> >       scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails
> > 
> > Julia Lawall (1):
> >       lpfc: introduce missing kfree
> > 
> > Martin Peschke (1):
> >       sg: fix device number in blktrace data
> > 
> > Mike Christie (1):
> >       libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
> > 
> > Robert Jennings (1):
> >       ibmvscsi: Correct DMA mapping leak
> > 
> > Shyam_Iyer@Dell.com (1):
> >       qla2xxx: fix Kernel Panic with Qlogic 2472 Card.
> 
> Did the mpt-fusion MSI problems get sorted out?  I think so...

Yes, but in the PCI tree.

> I believe that "scsi: mpt: suppress debugobjects warning" is 2.6.29
> material.  Sent 11 Feb, no response.

This is http://bugzilla.kernel.org/show_bug.cgi?id=12662 which is
reported fixed with no code changes.

> Also I believe that "hptiop: add new PCI device ID" should be in 2.6.29
> (and earlier), below.  I can send this on if you like.

I have this marked for inclusion, I'm just sending out the fixes that
have been incubating in next prior to reconstructing a new fixes tree.

James


