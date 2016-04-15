From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Fri, 15 Apr 2016 20:05:20 +0200
Message-ID: <57112D60.8020505@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-9-git-send-email-hare@suse.de>
 <57112B42.9050601@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbcDOSF0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 14:05:26 -0400
In-Reply-To: <57112B42.9050601@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/15/2016 07:56 PM, Bart Van Assche wrote:
> On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
>> Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
>> without error.
>
> Hello Hannes,
>
> Are you sure it's OK not to update blk_mq_direct_issue_request()?
>
Ah. Missed that one.
Will be updating the patch.

Thanks for the review.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
