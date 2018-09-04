From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: arm64/crct10dif - refactor and implement
 non-Crypto Extension version
Date: Tue, 4 Sep 2018 13:21:34 +0800
Message-ID: <20180904052134.5ax5j374gubxpo4s@gondor.apana.org.au>
References: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeff.lien@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 27, 2018 at 05:38:10PM +0200, Ard Biesheuvel wrote:
> The current arm64 CRC-T10DIF code only runs on cores that implement the
> 64x64 bit PMULL instructions that are part of the optional Crypto
> Extensions, and falls back to the highly inefficient C code otherwise.
> 
> Let's provide a SIMD version that is twice as fast as the C code even on
> a low end core like the Cortex-A53, and is time invariant and much easier
> on the D-cache.
> 
> Some performance numbers at the bottom.
> 
> Ard Biesheuvel (2):
>   crypto: arm64/crct10dif - preparatory refactor for 8x8 PMULL version
>   crypto: arm64/crct10dif - implement non-Crypto Extensions alternative
> 
>  arch/arm64/crypto/crct10dif-ce-core.S | 314 +++++++++++++++-----
>  arch/arm64/crypto/crct10dif-ce-glue.c |  14 +-
>  2 files changed, 251 insertions(+), 77 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
