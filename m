From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v8 0/7] ZBC / Zoned block device support
Date: Wed, 19 Oct 2016 08:15:49 +0900
Message-ID: <05d9cbd0-fb78-3f35-cc42-47f58640d184@wdc.com>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
 <2a80d950-c831-9ac6-1969-dc6386e58236@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52609 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbcJRXP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 19:15:56 -0400
In-Reply-To: <2a80d950-c831-9ac6-1969-dc6386e58236@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>

Jens,

On 10/19/16 00:58, Jens Axboe wrote:
> This is starting to look mergeable to me. Any objections in getting this
> applied for 4.10? Looks like 6/7 should go through the SCSI tree, but I
> can queue up the rest.

Yes, it would be great to get all this queued for 4.10. Indeed 6/7 is
SCSI, but if possible, it would be great to get it in the same tree as
the rest so that a single tree provides full ZBC support.
Martin, any objection ?

Thank you.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
