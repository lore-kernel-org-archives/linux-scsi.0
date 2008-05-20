From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
Date: Tue, 20 May 2008 23:34:24 +0800
Message-ID: <20080520153424.GA11687@gondor.apana.org.au>
References: <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080520023129.2f921f24.akpm@linux-foundation.org> <20080520093819.GA9147@gondor.apana.org.au> <20080520222531H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41575 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758048AbYETPet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 11:34:49 -0400
Content-Disposition: inline
In-Reply-To: <20080520222531H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Tue, May 20, 2008 at 10:25:25PM +0900, FUJITA Tomonori wrote:
>
> Does someone do DMA from/to __ctx?

Nobody.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
