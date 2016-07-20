From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Wed, 20 Jul 2016 10:07:17 +0900
Message-ID: <d8b161de-7178-48c6-45d0-1c5f1d834f58@hgst.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32961 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbcGTBH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 21:07:29 -0400
In-Reply-To: <1468934439-93579-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org


On 7/19/16 22:20, Hannes Reinecke wrote:
> Add a sysfs queue attribute 'zoned' to display the zone layout
> for zoned devices.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/blk-sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)

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

