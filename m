From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Simplify request tag decoding
Date: Tue, 06 Feb 2018 20:13:44 -0500
Message-ID: <yq1fu6d1u0n.fsf@oracle.com>
References: <20180126165219.11913-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932244AbeBGBOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 20:14:09 -0500
In-Reply-To: <20180126165219.11913-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Fri, 26 Jan 2018 08:52:19 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>


Bart,

> Since commit 64d513ac31bd ("scsi: use host wide tags by default") all
> SCSI requests have a tag, whether or not scsi-mq is enabled.
> Additionally, it is safe to use blk_mq_unique_tag() and
> blk_mq_unique_tag_to_hwq() for legacy SCSI queues. Since this means
> that the sdebug_mq_active variable is superfluous, remove it.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
