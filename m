From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for
	crc32c_intel
Date: Thu, 10 Mar 2011 16:43:46 +0800
Message-ID: <20110310084346.GA10650@gondor.apana.org.au>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-crypto-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 10, 2011 at 12:21:10AM -0800, Nicholas A. Bellinger wrote:
> 
> Nicholas Bellinger (2):
>   crypto: Add struct crypto_alg->cra_check_optimized
>   crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel

I think you misunderstood my suggestion.  The reason I asked
for this to be done in the crypto API is because it is not specific
to crc32c_intel.

So sending me a patch that modifies crc32c clearly misses the
point :)

This should be done in the core API, i.e., api.c/algapi.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
