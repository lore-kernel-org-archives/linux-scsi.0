From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 18/30] scsi/qla2xxx/: possible cleanups
Date: Fri, 14 Dec 2007 10:20:04 -0800
Message-ID: <20071214182004.GG1823@plap3.qlogic.org>
References: <200712140014.lBE0ELSg026228@imap1.linux-foundation.org> <20071214153723.GC1823@plap3.qlogic.org> <20071214095559.5d4dd818.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:58913 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLNSUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2007 13:20:08 -0500
Content-Disposition: inline
In-Reply-To: <20071214095559.5d4dd818.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@kernel.org

On Fri, 14 Dec 2007, Andrew Morton wrote:

> > Could you drop this patch from your queue.  I'll carry it in my tree
> > (along with additional code removals) for 2.6.25 submission.
> > 
> 
> I'll normally carry patches until they turn up in a subsystem tree or
> mainline and will drop them then.  To minimise potential of lossage..
> 
> Is your tree publically accessible?

It is, though, not widely publicized:

	git://avgit01.qlogic.com/qla2xxx-upstream

The repo is torndown and rebased on frequent a basis, and is meant to
provide a snapshot of where qla2xxx is at any given time.  Currently
it's comprised of linux-2.6.git with scsi-misc-2.6.git merged and a
dozen or so patches queued for the next merge window (2.6.25).

As it stands now, qla2xxx updates are still submitted via patches to
linux-scsi, rather than asking for any type of 'merge' to
scsi-misc-2.6.git be performed.
