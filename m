From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: An fc4 user appears
Date: Fri, 19 Mar 2010 07:17:28 -0600
Message-ID: <20100319131727.GE3875@parisc-linux.org>
References: <20100318184952.GB3875@parisc-linux.org> <17772.86388.qm@web52601.mail.re2.yahoo.com> <876254.4671.qm@web52601.mail.re2.yahoo.com> <20100317095222.GA16828@orion.carnet.hr> <201003181931.o2IJVSFj029524@yagi.h-net.msu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45682 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0CSNR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 09:17:29 -0400
Content-Disposition: inline
In-Reply-To: <201003181931.o2IJVSFj029524@yagi.h-net.msu.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dennis Boone <drb@msu.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2010 at 03:31:28PM -0400, Dennis Boone wrote:
>  > > fc4 was removed in October 2007 with this commit:
>  > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1ecd3902c6e16c2445165b872c49e73770b72da7
> 
>  > Yep, I removed it.  Resurrecting it will be quite a task.  Best of luck.
>  > I'm willing to answer questions (please cc linux-scsi), but not do the
>  > work.
> 
> Arrrrgh.  This kills all of the Sun Ex500 boxes.

I'm OK with that.  According to http://en.wikipedia.org/wiki/Sun_Enterprise
they haven't been produced since 2001.  I don't mind keeping support
for old products in Linux, but the fc4 layer was getting in the way
of improving the SCSI subsystem for current and future hardware.
That's not acceptable, so with no maintainer for the fc4 layer, the
only option was to remove it.  If you'd like to become fc4 maintainer,
or can find someone else to do it for you, it can go back in, no problem.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
