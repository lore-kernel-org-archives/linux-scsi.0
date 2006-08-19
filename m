From: maximilian attems <maks@sternwelten.at>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Sat, 19 Aug 2006 20:27:26 +0200
Message-ID: <20060819182726.GD4868@baikonur.stro.at>
References: <200608180959.16889.joshua@rubixlinux.org> <20060818163904.GC16593@athena.road.mcmartin.ca> <1155943138.3766.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:32264 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S1751498AbWHSS1e
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 14:27:34 -0400
Content-Disposition: inline
In-Reply-To: <1155943138.3766.9.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, 380272@bugs.debian.org
Cc: Kyle McMartin <kyle@parisc-linux.org>, Joshua Rubin <joshua@rubixlinux.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, stable@kernel.org

On Fri, Aug 18, 2006 at 04:18:58PM -0700, James Bottomley wrote:
> On Fri, 2006-08-18 at 12:39 -0400, Kyle McMartin wrote:
> > The problem is because they both claim support for the same PCI Ids:
> 
> That's this fix, isn't it?
> 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920
> 
> James

added the stable Maintainers to cc,
please consider this patch for the next revision.

thanks

-- 
maks
