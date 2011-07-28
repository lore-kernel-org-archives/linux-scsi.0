From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Date: Thu, 28 Jul 2011 08:55:08 -0700
Message-ID: <20110728085508.e8e00efe.rdunlap@xenotime.net>
References: <1311441452.23720.17.camel@mulgrave>
	<20110723102719.a7f26008.rdunlap@xenotime.net>
	<1311842979.30253.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311842979.30253.29.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 28 Jul 2011 12:49:39 +0400 James Bottomley wrote:

> On Sat, 2011-07-23 at 10:27 -0700, Randy Dunlap wrote:
> > On Sat, 23 Jul 2011 21:17:32 +0400 James Bottomley wrote:
> > 
> > > This represents the usual round of driver updates (fcoe, bfa, mpt2sas,
> > > iscsi, bnx2fc) plus a couple of fixes that didn't make 3.0 including the
> > > USB force eject oops.
> > > 
> > > The patch is available here:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > Hi James,
> > 
> > (please fix $subject)
> 
> Hmm, reusability gone too far
> 
> > What has happened to these 2 patches from 2011-June-21 ?
> > 
> > Subject: [PATCH] scsi: fix NCR_Q720 section mismatch warning
> > Subject: [PATCH] scsi: fix sim710 section mismatch warnings
> 
> Ralf is reworking them.  Basically there's no point mucking with
> creating work via the endless sectional annotators in obsolete drivers,
> so he was just going to strip the annotations where they cause problems.

Thanks for the info.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
