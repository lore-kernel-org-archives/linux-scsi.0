From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 2/4] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
Date: Wed, 19 Jun 2013 22:12:29 +0900
Message-ID: <CAC5umyivGS88R8SXoeqmgGkZFHDfN3GkaojDkfnbdX+NODwRyQ@mail.gmail.com>
References: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
	<1371562294-13642-3-git-send-email-akinobu.mita@gmail.com>
	<20130618143728.GE2767@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20130618143728.GE2767@htj.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2013/6/18 Tejun Heo <tj@kernel.org>:
> On Tue, Jun 18, 2013 at 10:31:32PM +0900, Akinobu Mita wrote:
>>  /**
>> + * sg_miter_seek - reposition mapping iterator
>> + * @miter: sg mapping iter to be seeked
>> + * @offset: number of bytes to plus the current location
>> + *
>> + * Description:
>> + *   Sets the offset of @miter to its current location plus @offset bytes.
>> + *
>> + * Notes:
>> + *   This function must be called just after sg_miter_start() or sg_miter_stop()
>
> It's not gonna be hard to make this function to handle any state,
> right?  Wouldn't it be better to do that?  It's a pretty generic
> feature after all.  Also, maybe a better name is sg_miter_skip()?

Yes.  This limitation can be removed by calling sg_miter_stop() at
the front of sg_miter_seek().  Also, renaming it to sg_miter_skip()
sounds good.
