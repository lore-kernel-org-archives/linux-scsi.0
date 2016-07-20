From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 6/6] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Wed, 20 Jul 2016 10:11:11 +0900
Message-ID: <b4fcf45d-91f0-6633-b6aa-28a96850e873@hgst.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48752 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbcGTBLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 21:11:24 -0400
In-Reply-To: <1468934439-93579-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 7/19/16 22:20, Hannes Reinecke wrote:
> Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
> without error.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  block/blk-mq.c          | 1 +
>  drivers/scsi/scsi_lib.c | 3 +++
>  include/linux/blk-mq.h  | 1 +
>  3 files changed, 5 insertions(+)

Reviewed-by: Damien Le Moal <damien.lemoal@hgst.com>
Tested-by: Damien Le Moal <damien.lemoal@hgst.com>

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

