From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Mon, 21 Jul 2014 10:15:32 +0200
Message-ID: <53CCCC24.5050403@redhat.com>
References: <53B2B4B2.8050100@redhat.com> <20140703060135.GA5292@infradead.org> <53B93FE3.8050607@redhat.com> <20140707101015.GB3544@infradead.org> <53BA95C0.3020607@redhat.com> <20140708095317.GA4306@infradead.org> <53BBBFC6.2030205@kernel.dk> <20140708095619.GA11196@infradead.org> <53BBC98C.4070004@kernel.dk> <53BBD51A.4070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbaGUIQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 04:16:03 -0400
In-Reply-To: <53BBD51A.4070704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

Hi,

On 07/08/2014 01:25 PM, Hans de Goede wrote:
> Hi,
> 
> On 07/08/2014 12:35 PM, Jens Axboe wrote:
>> On 2014-07-08 11:56, Christoph Hellwig wrote:
>>> On Tue, Jul 08, 2014 at 11:54:14AM +0200, Jens Axboe wrote:
>>>>> I've posted the patch in reply to another report and added Jens to the
>>>>> Cc list.  As the block maintainer he need to review and merge it.
>>>>
>>>> Which patch is this?
>>>
>>> This one:
>>>
>>> ---
>>> From: Christoph Hellwig <hch@lst.de>
>>> Subject: block: don't assume last put of shared tags is for the host
>>>
>>> There is no inherent reason why the last put of a tag structure must be
>>> the one for the Scsi_Host, as device model objects can be held for
>>> arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
>>> funtion that just release a references and get rid of the BUG() when the
>>> host reference wasn't the last.
>>
>> Thanks, applied. I don't think I was ever CC'ed on this one, though.
> 
> Thanks, good to hear.

It seems this one has not made it into 3.16-rc6 somehow ?

Regards,

Hans

