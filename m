From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] sd: Write lock zone for REQ_OP_WRITE_ZEROES
Date: Thu, 11 May 2017 23:12:35 -0400
Message-ID: <yq1fugaix98.fsf@oracle.com>
References: <20170508064819.12414-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16858 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755509AbdELDMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2017 23:12:45 -0400
In-Reply-To: <20170508064819.12414-1-damien.lemoal@wdc.com> (damien lemoal's
        message of "Mon, 8 May 2017 15:48:19 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>


Damien,

> For a zoned block device, sd_zbc_complete() handles zone write unlock
> on completion of a REQ_OP_WRITE_ZEROES command but the zone write
> locking is missing from sd_setup_write_zeroes_cmnd(). This patch fixes
> this problem by locking the target zone of a REQ_OP_WRITE_ZEROES
> request.

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
