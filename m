From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/7] hisi_sas: SATA IO workaround and other misc patches
Date: Fri, 20 Jan 2017 19:11:44 -0500
Message-ID: <yq11svxi85b.fsf@oracle.com>
References: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484916324-211630-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 20 Jan 2017 20:45:17 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces some misc fixes and improvements.  Most
John> signifigantly this patchset includes a workaround for a SATA IO
John> issue on v2 hw (hip06/7).

John> Differences v1->v2: - Add macro for SMP TIMEOUT in ITCT struct

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
