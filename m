From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Make megasas_host_device_list_query() static
Date: Mon, 15 Apr 2019 22:20:48 -0400
Message-ID: <yq1wojug073.fsf@oracle.com>
References: <20190413142138.33336-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190413142138.33336-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Sat, 13 Apr 2019 22:21:38 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Yue,

> Fix sparse warning:
>
> drivers/scsi/megaraid/megaraid_sas_base.c:4652:1: warning:
>  symbol 'megasas_host_device_list_query' was not declared. Should it be static?

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
