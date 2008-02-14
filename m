From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 19:11:53 -0600
Message-ID: <1202951513.3109.101.camel@localhost.localdomain>
References: <1202947364.3109.96.camel@localhost.localdomain>
	 <20080213161643.65a5a779.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47343 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935365AbYBNBL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 20:11:59 -0500
In-Reply-To: <20080213161643.65a5a779.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 16:16 -0800, Andrew Morton wrote:
> On Wed, 13 Feb 2008 18:02:44 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This one's not too bad given the number of patches we had in the merge
> > window.  We have the advansys fix, a gdth severe problem fix (wouldn't
> > scan any devices) a bug fix series for lpfc and a few other odds and
> > ends.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> I have scsi patches!
> 
> 
> 
> mptbase-reset-ioc-initiator-during-pci-resume.patch
> 
>   Fixes suspend/resume on all of Darrick's MPT cards.  I first merged it
>   in September 2007.

Patch presented by LSI but has gone back with comments

> kill-warnings-in-mptbaseh-on-parisc64.patch

>   Warning fixes.

Not sure ... LSI is supposed to be processing this.

> dell-cerc-support-for-megaraid_mbox.patch

I need megaraid to sign off (and test) this one.

>   Turns non-booting machiens into booting ones.  Merged in -mm in
>   November 2007.
> 
> 3w-raid-drivers-memset-not-needed-in-probe.patch
> 
>   Small optimisation
> 
> scsi-aic94xx-cleanups.patch
> 
>   cleanups only.
> 
> scsi-qlogicptic-section-fixes.patch
> 
>   Fixes a reference from .text into .init.text and hence might fix a
>   machine crash when this driver is build into vmlinux.  Merged a week ago.

This was the one we had the alternative fix for, wasn't it ... ?

> megaraid-outb_p-extermination.patch
> 
>   Cleanup
> 
> gdth-convert-to-pci-hotplug-api.patch
> 
>   Just merged

That's not a bug fix necessarily ... We do have an outstanding gdth bug
fix that did have a patch in your tree, though ...  But we're arguing
over doing it properly.

> 
> So several of these patches address quite seriosu bugs, and have been
> stuck in my tree for far too long.

James


