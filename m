From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: redefine hisi_sas_phy.phy_type as u32
Date: Mon, 26 Jun 2017 13:41:33 -0400
Message-ID: <yq1shim4pf6.fsf@oracle.com>
References: <1498472848-174945-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25287 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:41:48 -0400
In-Reply-To: <1498472848-174945-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 26 Jun 2017 18:27:28 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com


John,

> Element phy_type is a bitmask and it only ever has 2 bits possibly
> set, and it is overkill to define as a u64, so redefine as a u32.
>
> This change resolves static code check complaint that "phy->phy_type
> &= ~PORT_TYPE_SAS;" would unintentionally clear the high 32 bits as
> well.
>
> Structure hisi_sas_phy is also reordered to ensure packing efficiency.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
