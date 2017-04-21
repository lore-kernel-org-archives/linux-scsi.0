From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into sas_remove_host
Date: Fri, 21 Apr 2017 10:37:22 -0400
Message-ID: <yq1tw5hltct.fsf@oracle.com>
References: <20170421121141.20701-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50253 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161360AbdDUPhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 11:37:18 -0400
In-Reply-To: <20170421121141.20701-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 21 Apr 2017 14:11:41 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>


Johannes,

> Move scsi_remove_host call into sas_remove_host and remove it from SAS
> HBA drivers, so we don't mess up the ordering. This solves an issue
> with double deleting sysfs entries that was introduced by the change
> of sysfs behaviour from commit bcdde7e ("sysfs: make
> __sysfs_remove_dir() recursive").

Yeah, I prefer this approach.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
