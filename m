From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Sun, 10 Apr 2016 22:20:06 -0700
Message-ID: <CAF1ivSZSerbCO0MdELaTLbNUWMbeGBBv32-YO3sjHJZJYMQzrQ@mail.gmail.com>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
	<1459806491-16428-5-git-send-email-mlin@kernel.org>
	<20160405145555.GE7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38021 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbcDKFUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2016 01:20:10 -0400
In-Reply-To: <20160405145555.GE7822@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, Apr 5, 2016 at 7:55 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Apr 04, 2016 at 02:48:10PM -0700, Ming Lin wrote:
>> From: Ming Lin <ming.l@ssi.samsung.com>
>>
>> Rename SCSI_MAX_SG_SEGMENTS to SG_CHUNK_SIZE, which means the amount
>> we fit into a single scatterlist chunk.
>>
>> Rename SCSI_MAX_SG_CHAIN_SEGMENTS to SG_MAX_SEGMENTS.
>>
>> Will move these 2 generic definitions to scatterlist.h later.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Acked-by: Bart Van Assche <bart.vanassche@sandisk.com> (for ib_srp changes)
>> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
>
> For libata,
>
> Acked-by: Tejun Heo <tj@kernel.org>

Hi James,

Are we ready to merge it?

Thanks,
Ming
