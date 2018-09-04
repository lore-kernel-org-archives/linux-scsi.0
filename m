From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] crypto: Introduce notifier for new crypto
 algorithms
Date: Tue, 4 Sep 2018 13:21:51 +0800
Message-ID: <20180904052151.ys2mtoixeax6jj5w@gondor.apana.org.au>
References: <20180827060918.tfz7ljufqhlej4kq@gondor.apana.org.au>
 <20180830150016.15661-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830150016.15661-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 30, 2018 at 11:00:14AM -0400, Martin K. Petersen wrote:
> Introduce a facility that can be used to receive a notification
> callback when a new algorithm becomes available. This can be used by
> existing crypto registrations to trigger a switch from a software-only
> algorithm to a hardware-accelerated version.
> 
> A new CRYPTO_MSG_ALG_LOADED state is introduced to the existing crypto
> notification chain, and the register/unregister functions are exported
> so they can be called by subsystems outside of crypto.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/algapi.c         |  2 ++
>  crypto/algboss.c        |  2 ++
>  crypto/internal.h       |  8 --------
>  include/crypto/algapi.h | 10 ++++++++++
>  4 files changed, 14 insertions(+), 8 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
