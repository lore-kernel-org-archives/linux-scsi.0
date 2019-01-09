From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: Make protection lookup tables static and relocate functions
Date: Tue, 08 Jan 2019 22:30:23 -0500
Message-ID: <yq18szu4ieo.fsf@oracle.com>
References: <1546960492-218420-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546960492-218420-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 8 Jan 2019 23:14:52 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> Currently the protection lookup tables in sd_prot_flag_mask() and
> sd_prot_op() are declared as non-static. As such, they will be rebuilt
> for each respective function call.
>
> Optimise by making them static.

Applied to 5.1/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
