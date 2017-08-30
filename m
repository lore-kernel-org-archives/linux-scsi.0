From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH v4 2/3] Rework the code for caching Vital Product Data
 (VPD)
Date: Wed, 30 Aug 2017 00:04:51 +0000
Message-ID: <AT5PR84MB03086BAB891DFE32292E0481FD9C0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170829155013.11124-1-bart.vanassche@wdc.com>
 <20170829155013.11124-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hpe.com ([15.241.140.73]:53502 "EHLO
        g4t3427.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751374AbdH3AFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 20:05:13 -0400
In-Reply-To: <20170829155013.11124-3-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>


> Introduce the scsi_get_vpd_buf() and scsi_update_vpd_page()
> functions. The only functional change in this patch is that if
> updating page 0x80 fails that it is attempted to update page 0x83.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Acked-by: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane M Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c | 144 ++++++++++++++++++++++++--------------------------
> --
>  1 file changed, 66 insertions(+), 78 deletions(-)

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
