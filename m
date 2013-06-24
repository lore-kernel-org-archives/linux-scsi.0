From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/4] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
Date: Mon, 24 Jun 2013 16:27:53 -0700
Message-ID: <20130624232753.GQ1918@mtj.dyndns.org>
References: <1371991061-19437-1-git-send-email-akinobu.mita@gmail.com>
 <1371991061-19437-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371991061-19437-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 23, 2013 at 09:37:39PM +0900, Akinobu Mita wrote:
> The only difference between sg_pcopy_{from,to}_buffer() and
> sg_copy_{from,to}_buffer() is an additional argument that specifies
> the number of bytes to skip the SG list before copying.
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
