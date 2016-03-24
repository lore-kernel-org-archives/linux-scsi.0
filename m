From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v2 0/5] mempool based chained scatterlist alloc/free api
Date: Thu, 24 Mar 2016 08:09:05 -0700
Message-ID: <CAF1ivSaxn7KbiLt0ByHoC-EyP-Q0ah33YGNv0rLoO-=sOvia5w@mail.gmail.com>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
	<20160323074012.GA17929@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcCXPJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2016 11:09:57 -0400
In-Reply-To: <20160323074012.GA17929@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Mar 23, 2016 at 12:40 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Mar 22, 2016 at 03:03:11PM -0700, Ming Lin wrote:
>> From: Ming Lin <ming.l@ssi.samsung.com>
>>
>> The fist 4 patches make the SG related definitions/structs/functions
>> in SCSI code generic and the last patch move it to lib/sg_pool.c.
>>
>> I still keep the macro "SG_MEMPOOL_NR" since it's used in 3 places.
>
> I don't =D1=95ee the point, but I'm not going to block the series ove=
r
> it either.
>
> The new series looks really nice to me!
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hi James,

This series touches several sub-systems.
What's the best way to merge it?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
