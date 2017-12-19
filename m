From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: fix a warning reported by sparse
Date: Mon, 18 Dec 2017 22:41:26 -0500
Message-ID: <yq1bmivjsex.fsf@oracle.com>
References: <1513646123-93775-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937912AbdLSDlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2017 22:41:39 -0500
In-Reply-To: <1513646123-93775-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Tue, 19 Dec 2017 09:15:23 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chenxiang <chenxiang66@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com


chenxiang,

> The type of function pci_choose_state's return value is pci_power_t
> while we define it as a u32. A warning will be reported by sparse. So
> change u32 into pci_power_t.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
