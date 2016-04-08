From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
 alloc/free api
Date: Thu, 7 Apr 2016 22:41:08 -0700
Message-ID: <CAF1ivSYUyAyKRsBhk5LHJj8_UMKcN0UFzxoH0vz9=VGaqS6W_g@mail.gmail.com>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
	<1458081569-30953-2-git-send-email-mlin@kernel.org>
	<57067514.7020700@sandisk.com>
	<CAF1ivSZPyWJH9xHWARBTd4KSn1r4w7sR_98iH=8aaLPBqDoiog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36584 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcDHFlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 01:41:12 -0400
In-Reply-To: <CAF1ivSZPyWJH9xHWARBTd4KSn1r4w7sR_98iH=8aaLPBqDoiog@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Apr 7, 2016 at 9:43 AM, Ming Lin <mlin@kernel.org> wrote:
> On Thu, Apr 7, 2016 at 7:56 AM, Bart Van Assche
> <bart.vanassche@sandisk.com> wrote:
>> On 03/15/16 15:39, Ming Lin wrote:
>>>
>>> +static void sg_mempoll_free(struct scatterlist *sgl, unsigned int nents)
>>
>>
>> Please change mempoll into mempool.
>
> Good catch. Thanks Bart!

Hi Bart,

This is actually the previous old RFC patch.
The v2 and v3 patch series doesn't have this typo.

Thanks.
