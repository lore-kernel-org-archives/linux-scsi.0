From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.25-rc8
Date: Wed, 02 Apr 2008 13:16:14 -0500
Message-ID: <1207160174.3082.48.camel@localhost.localdomain>
References: <1207082197.3100.26.camel@localhost.localdomain>
	 <47F3CAFC.2050401@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41866 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483AbYDBSQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 14:16:18 -0400
In-Reply-To: <47F3CAFC.2050401@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2008-04-02 at 21:05 +0300, Boaz Harrosh wrote:
> On Tue, Apr 01 2008 at 23:36 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > This patch constitutes three bug fixes (the reversion of the BSG queue
> > fix is the most serious; without it we're getting eventual corruption in
> > systems).  The other two fix error legs or misleading reporting.  The
> > remaining 8 patches are all updates to the mvsas driver which was a late
> > addition at the -rc1 phase, so while they're not truly bug fixes, they
> > are enhancements to make that unreleased driver more roubust for 2.6.25.
> > 
> > The patch is here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > James Bottomley (2):
> >       libsas: Warn if ATA device detected but CONFIG_SCSI_SAS_ATA not set
> >       Revert " fix bsg queue oops with iscsi logout"
> > 
> <snip>
> 
> Does this mean that we still have the iscsi logout bug if used from bsg
> in 2.6.25 kernel? I just want to know what are the out-of-tree patches 
> I will need. Will the proper fix be candidate for the stable releases
> of 2.6.25?

I don't know yet.  The discussion is here:

http://marc.info/?t=120620205200001

James


