From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Tue, 14 Jul 2015 08:04:19 -0600
Message-ID: <55A516E3.8040708@fb.com>
References: <20150713142439.GA14427@kernel.dk> <20150714071358.GA31117@infradead.org> <55A4F0FD.6070305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54034 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbbGNOEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 10:04:44 -0400
In-Reply-To: <55A4F0FD.6070305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 07/14/2015 05:22 AM, Hannes Reinecke wrote:
> On 07/14/2015 09:13 AM, Christoph Hellwig wrote:
>> Looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> I wonder if we should start to gradually phase out these tuables in the
>> host template.  It's not really more complicated to set them directly
>> in the host anyway.
>
> Fully agreed. I would vote for making the host template read-only
> and modify all drivers to use the shost setting.

Indeed, that would be a much saner choice. The settings in a 
(effectively already) read-only host template seems like somewhat of a 
relic.

-- 
Jens Axboe

