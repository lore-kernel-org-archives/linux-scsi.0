From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V8 6/7] sd_zbc: Initialize device request queue zoned data
Date: Mon, 20 Nov 2017 21:36:55 -0500
Message-ID: <yq1a7zgnyrc.fsf@oracle.com>
References: <20171109065707.17210-1-damien.lemoal@wdc.com>
        <20171109065707.17210-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28458 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbdKUChH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 21:37:07 -0500
In-Reply-To: <20171109065707.17210-7-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 9 Nov 2017 15:57:06 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>


Damien,

> Initialize the seq_zones_bitmap, seq_zones_wlock and nr_zones fields
> of the disk request queue on disk revalidate. As the seq_zones_bitmap
> and seq_zones_wlock allocations are identical, introduce the helper
> sd_zbc_alloc_zone_bitmap(). Using this helper, reallocate the bitmaps
> whenever the disk capacity (number of zones) changes.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
