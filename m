From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Tue, 19 Jun 2007 19:16:11 +0200
Message-ID: <20070619171610.GH18863@kernel.dk>
References: <4677FD50.2090803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:5728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbXFSRQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 13:16:43 -0400
Content-Disposition: inline
In-Reply-To: <4677FD50.2090803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Bristow <paul@paulbristow.net>, Dave Gilbert <linux@treblig.org>, Russell King <rmk@arm.linux.org.uk>, Dave Alan Gilbert <gilbertd@cs.man.ac.uk>, Paul Clements <Paul.Clements@steeleye.com>, Pavel Machek <pavel@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, Eberhard Moenkeberg <emoenke@gwdg.de>, David van Leeuwen <avid@tm.tno.nl>, Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>, Heiko Schlittermann <heiko@lotte.sax.de>, Leo Spiekman <spiekman@dutette.et.tudelft.nl>, "Vadim V. Model" <model@cecmow.enet.dec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jun 19 2007, Boaz Harrosh wrote:
> From 6f4641911701cbdbe01516305b682012d8c6982a Mon Sep 17 00:00:00 2001
> Date: Tue, 19 Jun 2007 18:54:54 +0300
> 
>  I have unearthed very old bugs in stale drivers that still
>  used request->cmd as a READ|WRITE int.
>  This patch is maybe a proof that these drivers have not been
>  used for a long time. Should they be removed completely?

If you look at most of the code, it's inside ifdef debug statements or
comments most of them. So I don't think you can base any removal
suggestion on that.

The patch itself looks fine though, if you send one that isn't mangled
I'll apply it to the 2.6.23 branch.

-- 
Jens Axboe

