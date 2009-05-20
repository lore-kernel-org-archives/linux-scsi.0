From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
	block/for-2.6.31 tree
Date: Wed, 20 May 2009 12:11:38 -0500
Message-ID: <1242839498.2881.59.camel@localhost.localdomain>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>
	 <20090520111619.87f815b1.sfr@canb.auug.org.au>
	 <1242830240.2881.10.camel@localhost.localdomain>
	 <20090521004251.9160e228.sfr@canb.auug.org.au>
	 <1242830865.2881.13.camel@localhost.localdomain>
	 <1242836425.2881.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57934 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbZETRLf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 13:11:35 -0400
In-Reply-To: <1242836425.2881.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On Wed, 2009-05-20 at 16:20 +0000, James Bottomley wrote:
> On Wed, 2009-05-20 at 14:47 +0000, James Bottomley wrote:
> > OK, so I think your pulling of my posmerge tree can cope with the fact
> > that I did the necessary rebasing in block for-next before I made it the
> > base of my combined tree .... think of this as a nice test.
> > 
> > Just building now ... if it works, I'll push to SCSI post merge and all
> > our problems should go away.
> 
> Unfortunately the combined tree hits a BUG_ON blk-core.c:2045 when doing
> SPI domain validation.
> 
> There will be a short delay ...

OK, delay resolved.  With the additional oops fix patch, the tree now
boots and checks out.  I've pushed it, so it should show up in the next
linux-next.

James


