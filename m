From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] exofs: 3 changes to exofs & osd
Date: Tue, 18 Dec 2012 11:28:50 +0000
Message-ID: <1355830130.2630.23.camel@dabdike.int.hansenpartnership.com>
References: <50CF4E01.5030004@panasas.com>
	 <1355828291.2630.21.camel@dabdike.int.hansenpartnership.com>
	 <50D05106.5090200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54232 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab2LRL2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2012 06:28:53 -0500
In-Reply-To: <50D05106.5090200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, open-osd <osd-dev@open-osd.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2012-12-18 at 13:18 +0200, Boaz Harrosh wrote:
> On 12/18/2012 12:58 PM, James Bottomley wrote:
> > On Mon, 2012-12-17 at 18:53 +0200, Boaz Harrosh wrote:
> >> Hi Linus.
> >>
> >> Please pull the following changes since commit [ddffeb8c] Linux 3.7-rc1
> >> They are available in the git repository at:
> >>
> >>   git://git.open-osd.org/linux-open-osd.git for-linus
> >>
> >> for you to fetch changes up to
> >> 	[861d6660] exofs: don't leak io_state and pages on read error (2012-12-14 12:17:32 +0200)
> >>
> >> These are just 3 patches, the last two are bug fixes on the error paths
> >> in exofs.
> >>
> >> The important patch is the one to osd_uld which adds sysfs info to osd
> >> devices for use by user-mode clustering discovery software. I'm already
> >> sitting on this patch since before February this year, It is important for
> >> some of the big installation cluster systems, who's been compiling their
> >> own kernel just for that patch.
> > 
> > I'm a bit perplexed by this.  You got notice when it was added to the
> > SCSI tree and now it's already upstream:
> > 
> > commit 51976a8c85cec0c62e410bc38b8a11dbc690764d
> > Author: Boaz Harrosh <bharrosh@panasas.com>
> > Date:   Wed Oct 24 14:51:41 2012 -0700
> > 
> >     [SCSI] osd_uld: Add osdname & systemid sysfs at scsi_osd class
> > 
> > But the authorship info differs ... it looks like you forgot to include
> > the From: tag in your original patch send.
> > 
> 
> I'm so sorry, I completely goofed on this one. It's what happens when
> you are swamped with other work and are doing things without thinking.
> I totally forgot that I need to remove this patch. 
> 
> Both these patches where in linux-next for a long time. So I believe
> the merge will go just fine. Lets leave it like this, or I can rebase
> and remove it?

If it merges OK, I'd just leave it as is.  It wouldn't be anywhere close
to the first time we've had the same patch via different trees.

James


