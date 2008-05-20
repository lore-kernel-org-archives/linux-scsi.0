From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/4] block: use ARCH_KMALLOC_MINALIGN as the default
 dma pad mask
Date: Wed, 21 May 2008 01:09:41 +0900
Message-ID: <20080521010942W.tomof@acm.org>
References: <20080520093819.GA9147@gondor.apana.org.au>
	<20080520222531H.tomof@acm.org>
	<20080520153424.GA11687@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:54441 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYETQLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 12:11:39 -0400
In-Reply-To: <20080520153424.GA11687@gondor.apana.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, linux-mm@kvack.org

On Tue, 20 May 2008 23:34:24 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, May 20, 2008 at 10:25:25PM +0900, FUJITA Tomonori wrote:
> >
> > Does someone do DMA from/to __ctx?
> 
> Nobody.

Then, you don't need to use ARCH_KMALLOC_MINALIGN. 8 bytes align works
for you on all the architectures.
