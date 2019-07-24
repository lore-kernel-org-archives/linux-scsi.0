From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Make some functions static
Date: Tue, 23 Jul 2019 22:16:01 -0400
Message-ID: <yq1sgqwqise.fsf@oracle.com>
References: <20190723143450.33916-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190723143450.33916-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Tue, 23 Jul 2019 22:34:50 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fix sparse warnings:
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c:541:1: warning: symbol
> 'megasas_alloc_cmdlist_fusion' was not declared. Should it be static?

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
