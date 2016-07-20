From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 3/6] block: Implement support for zoned block devices
Date: Wed, 20 Jul 2016 10:05:58 +0900
Message-ID: <b5872a34-2729-85c5-8c49-486d31bb2d92@hgst.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22877 "EHLO
	esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbcGTBGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 21:06:13 -0400
In-Reply-To: <1468934439-93579-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org


On 7/19/16 22:20, Hannes Reinecke wrote:
> Implement a RB-Tree holding the zone information and
> add support functions for maintaining the RB-Tree.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/Kconfig          |  9 +++++++
>  block/Makefile         |  1 +
>  block/blk-core.c       |  5 ++++
>  block/blk-zoned.c      | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h | 47 +++++++++++++++++++++++++++++++++
>  5 files changed, 132 insertions(+)
>  create mode 100644 block/blk-zoned.c

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

