From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/8] hisi_sas internal abort support
Date: Thu, 25 Aug 2016 22:40:23 -0400
Message-ID: <yq14m68b6co.fsf@sermon.lab.mkp.net>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 24 Aug 2016 19:05:46 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces support for the internal abort feature
John> for the HiSilicon SAS controller.

John> The internal abort feature allows commands which are active in the
John> controller to be aborted before being sent to the slave device.

John> Only support will be added for v2 HW since v1 HW has issues in
John> supporting internal abort feature.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
