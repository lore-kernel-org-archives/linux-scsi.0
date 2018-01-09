From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/3] scsi: libsas: fix memory leak in sas_smp_get_phy_events()
Date: Mon, 08 Jan 2018 21:44:30 -0500
Message-ID: <yq1608bpx81.fsf@oracle.com>
References: <20180104130433.42813-1-yanaijie@huawei.com>
        <20180104130433.42813-2-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbeAICp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 21:45:26 -0500
In-Reply-To: <20180104130433.42813-2-yanaijie@huawei.com> (Jason Yan's message
        of "Thu, 4 Jan 2018 21:04:31 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, John Garry <john.garry@huawei.com>, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>


Jason,

> We've got a memory leak with the following producer:

Applied patches 1-3 to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
