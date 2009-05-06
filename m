From: maximilian attems <max@stro.at>
Subject: Re: Bug#527265: [scott.bailey@eds.com: Bug#527265: linux-image-2.6.29-1-alpha-smp: detached firmware qlogic/1040.bin fails to load for qla1280]
Date: Wed, 6 May 2009 17:35:07 +0200
Message-ID: <20090506153507.GB31614@baikonur.stro.at>
References: <20090506141912.GA31614@baikonur.stro.at> <1241621070.3322.17.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:41948 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZEFPi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 11:38:26 -0400
Content-Disposition: inline
In-Reply-To: <1241621070.3322.17.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, 527265@bugs.debian.org
Cc: linux-scsi@vger.kernel.org, "R. Scott Bailey" <scott.bailey@eds.com>

On Wed, May 06, 2009 at 02:44:30PM +0000, James Bottomley wrote:
> On Wed, 2009-05-06 at 16:19 +0200, maximilian attems wrote:
> >  [4194023.390744] ------------[ cut here ]------------
> >  [4194023.448362] WARNING: at /build/buildd-linux-2.6_2.6.29-3-alpha-bvFcox/linux-2.6-2.6.29/debian/build/source_alpha_none/kernel/so
> 
> Is there any way we can get what that file and line actually is?  It
> looks like the kernel build hasn't truncated the path name to top of
> tree for some reason (did you build with non standard options)?

no idea, i can retry to rebuild on alpha,
haven't build for that arch in a while.
 
> I suspect it might just be a lockdep error about calling request
> firmware with interrupts disabled.
> 
> Could you also check to see you have this fix in your kernel:
> 
> commit 0ce49d6da993adf8b17b7f3ed9805ade14a6a6f3
> Author: David Woodhouse <David.Woodhouse@intel.com>
> Date:   Wed Apr 8 01:22:36 2009 -0700
> 
>     qla1280: Fix off-by-some error in firmware loading.
> 
> James
> 

ouch, right we missed that one, added will be in next upload of 2.6.29
aka package version 2.6.29-5.

