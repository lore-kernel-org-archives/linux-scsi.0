From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 07 Jan 2008 23:17:12 +1100
Message-ID: <E1JBqum-0006wC-00@gondolin.me.apana.org.au>
References: <4781E6BB.2010900@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4781E6BB.2010900@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: rusty@rustcorp.com.au, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
>
> /me agrees.  As long as this can be made sane using one unified
> interface, I don't care whether it's sg_ring, table or dish.

Give us sg_annulus :)

On a more serious note, having played with SG chaining for a couple
of years in the crypto layer, I must say Rusty's proposal is a great
improvement for me.  The reason is that if the crypto layer gets an
SG list from its user, it is not at liberty to just modify it.  As
such chaining at the end is cumbersome with the current interface
because we have to duplicate the whole list in order to add just a
single block at the end.

While with sg_ring we could just put the original list along with the
new one in a new list.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
