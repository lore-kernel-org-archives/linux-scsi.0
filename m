From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 8/9] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Fri, 15 Apr 2016 10:56:18 -0700
Message-ID: <57112B42.9050601@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0053.outbound.protection.outlook.com ([157.56.110.53]:40416
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbcDOR4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 13:56:24 -0400
In-Reply-To: <1459764020-126038-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
> without error.

Hello Hannes,

Are you sure it's OK not to update blk_mq_direct_issue_request()?

Bart.
