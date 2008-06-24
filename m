From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blk request timeout handler against 2.6.26
Date: Tue, 24 Jun 2008 12:16:10 +0200
Message-ID: <20080624101610.GN20851@kernel.dk>
References: <20080503020000.GU14976@parisc-linux.org> <20080507074357.GP329@kernel.dk> <20080513032012.GC9511@us.ibm.com> <20080619171741.GB819@linux.vnet.ibm.com> <20080620083738.GX20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17822 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYFXKQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 06:16:12 -0400
Content-Disposition: inline
In-Reply-To: <20080620083738.GX20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, Jun 20 2008, Jens Axboe wrote:
> On Thu, Jun 19 2008, Mike Anderson wrote:
> > Jens,
> > 
> > What is the status of the blk request timeout handler patches? I noticed
> > the branch is showing no update for 7 months and the updates sent to the
> > list received no response.
> > 
> > I was working on a abort function patch on top of the timeout patches to
> > see if I could speed up some multipath failure over cases and wanted to
> > understand if the blk timeout patch set was still a valid patch set.
> 
> It's still alive, I'll update the branch with the latest stuff. Perhaps
> we can even make 2.6.27, it should be about ready-cooked now.

I've updated the branch, mostly directly based on the updates and
patches from Malahal.


-- 
Jens Axboe

