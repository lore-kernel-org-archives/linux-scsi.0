From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Wed, 21 May 2008 11:16:46 +0800
Message-ID: <20080521031646.GA16565@gondor.apana.org.au>
References: <20080520153424.GA11687@gondor.apana.org.au> <20080521010942W.tomof@acm.org> <20080521012622.GA15850@gondor.apana.org.au> <20080521103651P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43977 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753698AbYEUDQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 23:16:58 -0400
Content-Disposition: inline
In-Reply-To: <20080521103651P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Wed, May 21, 2008 at 10:36:51AM +0900, FUJITA Tomonori wrote:
>
> ARCH_KMALLOC_MINALIGN represents DMA alignment since we guarantee
> kmalloced buffers can be used for DMA.

That may be why it was created, but that is not its only application.
In particular, it forms part of the calculation of the minimum
alignment guaranteed by kmalloc which is why it's used in crpyto.

Of course, if some kind soul would move this calculation into a
header file then we wouldn't be having this discussion.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
