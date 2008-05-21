From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Wed, 21 May 2008 16:47:00 +0800
Message-ID: <20080521084700.GA18644@gondor.apana.org.au>
References: <20080521012622.GA15850@gondor.apana.org.au> <20080521103651P.fujita.tomonori@lab.ntt.co.jp> <20080521031646.GA16565@gondor.apana.org.au> <20080521155414D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36276 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbYEUIrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2008 04:47:13 -0400
Content-Disposition: inline
In-Reply-To: <20080521155414D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Wed, May 21, 2008 at 03:54:14PM +0900, FUJITA Tomonori wrote:
>
> As explained, with the current way we define ARCH_KMALLOC_MINALIGN,
> crypto doesn't need to use it. But to make it clear, we had better
> clean up these defines, such as renaming it an appropriate name like
> ARCH_DMA_ALIGN.

No you don't understand the way crypto is using it.  We need to
know exactly the minimum alignment guaranteed by kmalloc.  Too much
or too little are both buggy.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
