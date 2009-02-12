From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [patch 10/11] sg_io: don't perform unneeded copy in compat code
Date: Thu, 12 Feb 2009 10:35:10 +0900
Message-ID: <20090212103526D.fujita.tomonori@lab.ntt.co.jp>
References: <200902112129.n1BLTdk4002476@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60603 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbZBLBgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 20:36:05 -0500
In-Reply-To: <200902112129.n1BLTdk4002476@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, alexey.zaytsev@gmail.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com

On Wed, 11 Feb 2009 13:29:38 -0800
akpm@linux-foundation.org wrote:

> From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> 
> The members from 'status' in struct sg_io_hdr to the last are used to
> transfer information from kernel to user space.  The values that user
> space sets are just ignored.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/compat_ioctl.c |    6 ------
>  1 file changed, 6 deletions(-)

Looks fine to me.
