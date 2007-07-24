From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] unexport sg v3 helper functions
Date: Tue, 24 Jul 2007 08:49:55 +0200
Message-ID: <20070724064954.GD3287@kernel.dk>
References: <20070722033008L.tomof@acm.org> <20070723120222.GI11657@kernel.dk> <46A57410.1090605@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9116 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbXGXGte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 02:49:34 -0400
Content-Disposition: inline
In-Reply-To: <46A57410.1090605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Jul 23 2007, Douglas Gilbert wrote:
> Jens Axboe wrote:
> > On Sun, Jul 22 2007, FUJITA Tomonori wrote:
> >> blk_fill_sghdr_rq, blk_unmap_sghdr_rq, and blk_complete_sghdr_rq were
> >> exported for bsg, however bsg was changed to support only sg v4.
> >>
> >> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Why?

The reasoning is right there, a few lines up - bsg doesn't support sg v3
commands.

-- 
Jens Axboe

