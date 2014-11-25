From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Tue, 25 Nov 2014 09:36:54 -0700
Message-ID: <5474B026.3040900@fb.com>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20141125162620.GA31478@infradead.org> <5474AE9B.40104@fb.com> <20141125163241.GA25295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33279 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbaKYQiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 11:38:05 -0500
In-Reply-To: <20141125163241.GA25295@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On 11/25/2014 09:32 AM, Christoph Hellwig wrote:
> On Tue, Nov 25, 2014 at 09:30:19AM -0700, Jens Axboe wrote:
>> On 11/25/2014 09:26 AM, Christoph Hellwig wrote:
>>> This looks reasonable to me.  Jens, do you want to takes this
>>> through the block tree?
>>>
>>> Acked-by: Christoph Hellwig <hch@lst.de>
>>
>> Yeah I can do that, though do we really need to do paride here?
> 
> Well, no need to keep the mutex around in paride for no reason.  But my
> preference would be to just kill off paride anyway :)

That's sort of my point. Performance optimization and paride, well...
But it's not a huge deal, we can apply it.

-- 
Jens Axboe

