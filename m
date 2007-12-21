From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 18/30] scsi/qla2xxx/: possible cleanups
Date: Fri, 21 Dec 2007 02:46:46 -0800
Message-ID: <20071221024646.43013267.akpm@linux-foundation.org>
References: <200712140014.lBE0ELSg026228@imap1.linux-foundation.org>
	<20071214153723.GC1823@plap3.qlogic.org>
	<20071214095559.5d4dd818.akpm@linux-foundation.org>
	<20071214182004.GG1823@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbXLUKrL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 05:47:11 -0500
In-Reply-To: <20071214182004.GG1823@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@kernel.org

On Fri, 14 Dec 2007 10:20:04 -0800 Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> On Fri, 14 Dec 2007, Andrew Morton wrote:
> 
> > > Could you drop this patch from your queue.  I'll carry it in my tree
> > > (along with additional code removals) for 2.6.25 submission.
> > > 
> > 
> > I'll normally carry patches until they turn up in a subsystem tree or
> > mainline and will drop them then.  To minimise potential of lossage..
> > 
> > Is your tree publically accessible?
> 
> It is, though, not widely publicized:
> 
> 	git://avgit01.qlogic.com/qla2xxx-upstream
>
> The repo is torndown and rebased on frequent a basis, and is meant to
> provide a snapshot of where qla2xxx is at any given time.  Currently
> it's comprised of linux-2.6.git with scsi-misc-2.6.git merged and a
> dozen or so patches queued for the next merge window (2.6.25).

That should be OK.  Sometimes ugly things can happen if James syncs with
Linus and you don't: when I ask git to generate the james->you diff, it
will generate a patch which reverts the Linus changes which are in James's
tree but which aren't in yours.  I have an alternative pull-git-trees
script which tries to fix that but not very successfully.

But whatever, we'll see.

One slight problem though:

fatal: Unable to look up avgit01.qlogic.com (port 9418) (Name or service not known)

I think I might need to be akpm@qlogic.com to get at that?

