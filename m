From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default
 dma pad mask
Date: Wed, 21 May 2008 18:34:45 +0900
Message-ID: <20080521183429O.tomof@acm.org>
References: <20080521031646.GA16565@gondor.apana.org.au>
	<20080521155414D.fujita.tomonori@lab.ntt.co.jp>
	<20080521084700.GA18644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58804 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYEUJgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 05:36:19 -0400
In-Reply-To: <20080521084700.GA18644@gondor.apana.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Wed, 21 May 2008 16:47:00 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, May 21, 2008 at 03:54:14PM +0900, FUJITA Tomonori wrote:
> >
> > As explained, with the current way we define ARCH_KMALLOC_MINALIGN,
> > crypto doesn't need to use it. But to make it clear, we had better
> > clean up these defines, such as renaming it an appropriate name like
> > ARCH_DMA_ALIGN.
> 
> No you don't understand the way crypto is using it.  We need to
> know exactly the minimum alignment guaranteed by kmalloc.  Too much
> or too little are both buggy.

Why do crypto need to know exactly the minimum alignment guaranteed by
kmalloc? Can you tell me an example how the alignment breaks crypto?

For me, the way crypto use it is idential to what the hostdata in
struct Scsi_Host does.
