From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into
 sas_remove_host
Date: Mon, 24 Apr 2017 11:09:03 +0100
Message-ID: <c3ddfbfd-1b4f-d53b-d9b3-9d475985ce9e@huawei.com>
References: <20170421121141.20701-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:5789 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1167293AbdDXKJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 06:09:30 -0400
In-Reply-To: <20170421121141.20701-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, Linuxarm <linuxarm@huawei.com>

On 21/04/2017 13:11, Johannes Thumshirn wrote:
> Move scsi_remove_host call into sas_remove_host and remove it from SAS HBA
> drivers, so we don't mess up the ordering. This solves an issue with double
> deleting sysfs entries that was introduced by the change of sysfs behaviour
> from commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
> Cc: John Garry <john.garry@huawei.com>

For what it's worth:

Tested-by: John Garry <john.garry@huawei.com> # On hisi_sas
