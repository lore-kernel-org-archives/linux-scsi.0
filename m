From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Change frame type for SET MAX commands
Date: Mon, 08 Jan 2018 22:47:04 -0500
Message-ID: <yq1po6jn16v.fsf@oracle.com>
References: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756630AbeAID5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 22:57:23 -0500
In-Reply-To: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Thu, 28 Dec 2017 18:20:45 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chenxiang <chenxiang66@hisilicon.com>
Cc: martin.petersen@oracle.com, tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com


chenxiang,

> According to ATA protocol, there are two other values for SET MAX commands' 
> feature field. So definite them. Also those SET MAX commands belong to 
> different frame types,and judge feature field of SET MAX commands to decide
> which frame type they belongs to.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
