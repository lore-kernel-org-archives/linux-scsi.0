From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 2/3] sd: enable single-threaded I/O submission for zoned
 devices
Date: Wed, 20 Jul 2016 10:15:12 +0900
Message-ID: <e873ab94-40fd-1c35-378a-2074d58548fe@hgst.com>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
 <1468936978-9124-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39566 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbcGTBPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 21:15:24 -0400
In-Reply-To: <1468936978-9124-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>


On 7/19/16 23:02, Hannes Reinecke wrote:
> zoned devices require single-thread I/O submission to guarantee
> sequential I/O, so enable the block layer flag for it.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 1 +
>  1 file changed, 1 insertion(+)

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

