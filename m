From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Tue, 27 Sep 2016 08:30:17 +0900
Message-ID: <61629301-8347-f217-8d74-d38b312f7c21@hgst.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
 <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com>
 <20160926163752.GA13876@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160926163752.GA13876@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org


Christoph,

On 9/27/16 01:37, Christoph Hellwig wrote:
>> -/*
>> - * Zone type.
>> - */
>> -enum blk_zone_type {
>> -	BLK_ZONE_TYPE_UNKNOWN,
>> -	BLK_ZONE_TYPE_CONVENTIONAL,
>> -	BLK_ZONE_TYPE_SEQWRITE_REQ,
>> -	BLK_ZONE_TYPE_SEQWRITE_PREF,
>> -};
> 
> Please don't move this code around after it was added just two
> patches earlier.  I'd say just split adding the new blkzoned.h
> uapi header into a patch of it's own and add that before the
> core block code.

Or we could just simply merge patches 5 and 7... Even more simple.
Would that be OK ? Shaun, any objection ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com
