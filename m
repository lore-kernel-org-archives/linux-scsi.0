From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas: Fix rphy phy_identifier for PHYs with end devices attached
Date: Fri, 15 Feb 2019 22:17:01 -0500
Message-ID: <yq1va1kmngy.fsf@oracle.com>
References: <1550162277-17615-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550162277-17615-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 15 Feb 2019 00:37:57 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dann.frazier@canonical.com, yanaijie@huawei.com
List-Id: linux-scsi@vger.kernel.org


John,

> The sysfs phy_identifier attribute for a sas_end_device comes
> from the rphy phy_identifier value.

Applied to 5.0/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
