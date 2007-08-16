From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] ppc sg chaining support fixes
Date: Thu, 16 Aug 2007 08:51:10 +0200
Message-ID: <20070816065110.GG23758@kernel.dk>
References: <20070816081557R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26482 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbXHPGvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2007 02:51:13 -0400
Content-Disposition: inline
In-Reply-To: <20070816081557R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, paulus@samba.org

On Thu, Aug 16 2007, FUJITA Tomonori wrote:
> This is for the sglist branch in Jens' block git tree.
> 
> ---
> From 445923d1a8ff272293af3aadb6e58f82e6439e98 Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 16 Aug 2007 02:25:32 +0900
> Subject: [PATCH] ppc sg chaining support fixes
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/powerpc/kernel/iommu.c       |    5 +++--
>  include/asm-powerpc/dma-mapping.h |   15 +++++++++------
>  2 files changed, 12 insertions(+), 8 deletions(-)

Thanks Tomo!

-- 
Jens Axboe

