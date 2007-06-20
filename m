From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Wed, 20 Jun 2007 12:59:12 +0200
Message-ID: <20070620105912.GQ18863@kernel.dk>
References: <4677FD50.2090803@panasas.com> <20070619171610.GH18863@kernel.dk> <4679072C.2010604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18449 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXFTK7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jun 2007 06:59:52 -0400
Content-Disposition: inline
In-Reply-To: <4679072C.2010604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jun 20 2007, Boaz Harrosh wrote:
> Jens Axboe wrote:
> > 
> > If you look at most of the code, it's inside ifdef debug statements or
> > comments most of them. So I don't think you can base any removal
> > suggestion on that.
> > 
> > The patch itself looks fine though, if you send one that isn't mangled
> > I'll apply it to the 2.6.23 branch.
> > 
> Sorry new Thunderbird Installation. I forgot it does that.

The new patch applies cleanly, except on nbd where it fails. It suceeds
with -l to ignore white space, so perhaps your mail setup isn't 100% up
to standard yet :-)

-- 
Jens Axboe

