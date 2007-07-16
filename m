From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 15:23:59 +0200
Message-ID: <20070716132359.GQ5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:27532 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977AbXGPNYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:24:42 -0400
Content-Disposition: inline
In-Reply-To: <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: mark_salyzyn@adaptec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Jul 16 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: [PATCH 00/33] SG table chaining support
> Date: Mon, 16 Jul 2007 11:47:14 +0200
> 
> > Changes since last post:
> > 
> > - Rebase to current -git. Lots of SCSI drivers have been converted
> >   to use the sg accessor helpers, which nicely shrinks this patchset
> >   from 70 to 33 patches. Great!
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ips: sg chaining support
> 
> ips properly uses scsi_for_each_sg for the normal I/O path, however,
> the breakup path doesn't.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks, applied!

-- 
Jens Axboe

