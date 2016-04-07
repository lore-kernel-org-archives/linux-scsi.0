From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
 alloc/free api
Date: Thu, 7 Apr 2016 09:43:52 -0700
Message-ID: <CAF1ivSZPyWJH9xHWARBTd4KSn1r4w7sR_98iH=8aaLPBqDoiog@mail.gmail.com>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
	<1458081569-30953-2-git-send-email-mlin@kernel.org>
	<57067514.7020700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57067514.7020700@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 7, 2016 at 7:56 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 03/15/16 15:39, Ming Lin wrote:
>>
>> +static void sg_mempoll_free(struct scatterlist *sgl, unsigned int nents)
>
>
> Please change mempoll into mempool.

Good catch. Thanks Bart!
