From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/nsp32.c: remove kernel 2.4 code
Date: Fri, 27 Apr 2007 17:01:24 +0200
Message-ID: <20070427150124.GU3468@stusta.de>
References: <20070426234742.GH3468@stusta.de> <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain> <20070427001324.GP3468@stusta.de> <1177633855.5532.8.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0704271051240.22643@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36538 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbXD0PBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 11:01:13 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704271051240.22643@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>, GOTO Masanori <gotom@sanori.org>

On Fri, Apr 27, 2007 at 10:55:54AM -0400, Robert P. J. Day wrote:
> On Thu, 26 Apr 2007, James Bottomley wrote:
> 
> > Personally, I don't like to see 2.4 and 2.6 in a new driver, and
> > will tend to try to force it to be 2.6 only.  For an existing
> > driver, I tend to be much more tolerant: removing the huge gobs of
> > code to achieve 2.6 only is usually a bit disruptive on both the
> > driver and the maintainer
> >
> > > But if a driver is no longer actually maintained for both kernels
> > > these checks become useless (and there quickly arised
> > > unconditional 2.6-only code in such a driver) and can be removed.
> >
> > This driver is maintained by
> >
> > Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>
> > GOTO Masanori <gotom@sanori.org>
> >
> > As it says in the header.  It was last modified in May 2006, so it
> > is maintained under the somewhat elastic standards of SCSI.  I've
> > cc'd them to see what they think.
> 
> while we're on the subject, what's the policy on supporting kernel
> version selection *within* the 2.5 series?  as in:
> 
> $ grep -r "KERNEL_VERSION(2,5" *
> drivers/scsi/pcmcia/nsp_cs.h:#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
> drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
> drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
> drivers/scsi/pcmcia/nsp_cs.c:#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
> ... etc etc ...
> 
> granted, this doesn't happen in a lot of files (almost of them
> SCSI-related), but is it official policy to support code based on its
> release number in the 2.5 series of releases?  unless you have a good
> reason, wouldn't it make more sense to compare against (2,6,0) rather
> than, say, (2,5,73)?  just an observation.

Besides the fact that I sent a patch to remove the compat code from this 
driver, it simply doesn't matter whether to compare with (2,5,73) or 
(2,6,0), so there's no reason for changing it.

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

