From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] lib/scatterlist: factor out
 sg_miter_get_next_page() from sg_miter_next()
Date: Tue, 18 Jun 2013 07:35:05 -0700
Message-ID: <20130618143505.GD2767@htj.dyndns.org>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
 <1371562294-13642-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371562294-13642-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2013 at 10:31:31PM +0900, Akinobu Mita wrote:
> This function is used to proceed page iterator to the next page if
> necessary, and will be used to implement the variants of
> sg_copy_{from,to}_buffer() later.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
