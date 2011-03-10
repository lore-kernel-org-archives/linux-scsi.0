From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Date: Thu, 10 Mar 2011 00:54:24 -0800
Message-ID: <1299747264.5263.35.camel@haakon2.linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
	 <20110310084346.GA10650@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110310084346.GA10650@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-03-10 at 16:43 +0800, Herbert Xu wrote:
> On Thu, Mar 10, 2011 at 12:21:10AM -0800, Nicholas A. Bellinger wrote:
> > 
> > Nicholas Bellinger (2):
> >   crypto: Add struct crypto_alg->cra_check_optimized
> >   crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel
> 
> I think you misunderstood my suggestion.  The reason I asked
> for this to be done in the crypto API is because it is not specific
> to crc32c_intel.
> 
> So sending me a patch that modifies crc32c clearly misses the
> point :)
> 
> This should be done in the core API, i.e., api.c/algapi.c.
> 

OK, so you mean each struct crypto_alg should define something like a
'cra_optimized_name' for which request_module(alg->cra_optimized_name)
is called somewhere in libcrypto code..?

Would you mind being a bit more specific where this should be happening
in api.c/algapi.c..?

Thanks,

--nab
