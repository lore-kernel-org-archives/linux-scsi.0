From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/10] hisi_sas: support x6000 board and some misc changes
Date: Mon, 12 Mar 2018 21:59:07 -0400
Message-ID: <yq1efkog2hg.fsf@oracle.com>
References: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520425514-205565-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 7 Mar 2018 20:25:04 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com, hare@suse.de, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset primarily adds support for the Huawei x6000 board,
> which includes hip07 chipset. Unfortunately, due to some board
> layout differences with our development board, we need to set
> a PHY-related register differently for optimal signal quality. As
> such, a signal attenuation property is added to describe the
> differences in the boards and allow the PHY register to be set
> appropriately.

Applied to 4.17/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
