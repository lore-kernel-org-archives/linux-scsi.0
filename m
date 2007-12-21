From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Fri, 21 Dec 2007 20:13:07 +0800
Message-ID: <E1J5gkV-0000Ig-00@gondolin.me.apana.org.au>
References: <200712211013.38511.rusty@rustcorp.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4513 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756448AbXLUMNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2007 07:13:22 -0500
In-Reply-To: <200712211013.38511.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> 2) It allows others to manipulate sg chains, which couldn't be done before
>   (eg. the ATA code which wants to append a padding element).

Yes chaining at the end is very useful for the crypto layer as
well.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
