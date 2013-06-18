From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
Date: Tue, 18 Jun 2013 07:37:28 -0700
Message-ID: <20130618143728.GE2767@htj.dyndns.org>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
 <1371562294-13642-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371562294-13642-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2013 at 10:31:32PM +0900, Akinobu Mita wrote:
>  /**
> + * sg_miter_seek - reposition mapping iterator
> + * @miter: sg mapping iter to be seeked
> + * @offset: number of bytes to plus the current location
> + *
> + * Description:
> + *   Sets the offset of @miter to its current location plus @offset bytes.
> + *
> + * Notes:
> + *   This function must be called just after sg_miter_start() or sg_miter_stop()

It's not gonna be hard to make this function to handle any state,
right?  Wouldn't it be better to do that?  It's a pretty generic
feature after all.  Also, maybe a better name is sg_miter_skip()?

Thanks.

-- 
tejun
