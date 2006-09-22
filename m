From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] [PATCH] helper function for retrieving scsi_cmd given  host based block layer tag
Date: Fri, 22 Sep 2006 21:11:57 +0200
Message-ID: <20060922191156.GL16556@kernel.dk>
References: <1158710201.4358.8.camel@dcslnxpc.site> <1158944997.4040.10.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:61551 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S932133AbWIVTHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 15:07:18 -0400
Content-Disposition: inline
In-Reply-To: <1158944997.4040.10.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>

On Fri, Sep 22 2006, David C Somayajulu wrote:
> On Tue, 2006-09-19 at 16:56 -0700, David C Somayajulu wrote:
> > This was necessitated by the need for a function to get back
> > to a scsi_cmnd, when an hba the posts its (corresponding) completion 
> > interrupt with a block layer tag as its reference.
> Regenerated the patch with reference to
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> Also fixed tabs.
> 
> Here is the link to the same patch with reference scsi-misc just in case
> ( ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/blk_tag_helper_patch.txt  )
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

It still fails for me:

axboe@nelson:/src/linux-2.6-block.git $ patch -p1 --dry-run < ~/1
patching file block/ll_rw_blk.c
Hunk #1 succeeded at 840 (offset 3 lines).
patching file include/linux/blkdev.h
Hunk #1 succeeded at 766 (offset 19 lines).
patching file include/scsi/scsi_tcq.h
Hunk #1 FAILED at 131.
1 out of 1 hunk FAILED -- saving rejects to file
include/scsi/scsi_tcq.h.rej

I wonder if you are using the 'block' branch, not just the master
branch? It seems to apply perfectly there, but that is just the same as
Linus' tree. So when you have cloned the block git repo, there are a
number of branches you can work against. The main branch with current
changes is the 'block' branch, that is what you want to be making
patches against.

I'll be away for the entire next week, so no rush on my end.

-- 
Jens Axboe

