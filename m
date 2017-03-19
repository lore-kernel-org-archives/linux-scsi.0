From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas: fix ata xfer length
Date: Sun, 19 Mar 2017 13:21:52 -0400
Message-ID: <yq160j5ji6n.fsf@oracle.com>
References: <1489676848-103256-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46633 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdCSRWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2017 13:22:37 -0400
In-Reply-To: <1489676848-103256-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 16 Mar 2017 23:07:28 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com

John Garry <john.garry@huawei.com> writes:

John,

> The total ata xfer length may not be calculated properly,
> in that we do not use the proper method to get an sg element
> dma length.
>
> According to the code comment, sg_dma_len() should be used
> after dma_map_sg() is called.
>
> This issue was found by turning on the SMMUv3 in front of
> the hisi_sas controller in hip07. Multiple sg elements
> were being combined into a single element, but the original
> first element length was being use as the total xfer length.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
