From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: Set protection parameters prior to adding SCSI host
Date: Fri, 11 Jan 2019 21:39:13 -0500
Message-ID: <yq1h8eey4z2.fsf@oracle.com>
References: <1547127161-213124-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547127161-213124-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 10 Jan 2019 21:32:41 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> Currently we set the protection parameters after calling scsi_add_host()
> for v3 hw.
>
> They should be set beforehand, so make this change.

Applied to 5.0/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
