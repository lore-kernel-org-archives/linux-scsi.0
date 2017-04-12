From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] hisi_sas: v2 hw SoC bug workarounds
Date: Tue, 11 Apr 2017 22:02:11 -0400
Message-ID: <yq1zifmtmcc.fsf@oracle.com>
References: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491830521-21437-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 10 Apr 2017 21:21:55 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset introduces some v2 hw bug workarounds. Mostly they are
> related to SATA devices, but there is also a workaround for a scenario
> when internal abort command may timeout.
>
> The general rule for implementing workarounds was to do it in the hw
> layer, as the next hw revision should not include these bugs, so it is
> better not pollute the driver main layer with workarounds
>
> This patchset also includes 2 other patches, one for a possible NULL
> pointer deference and another for resetting the controller for fatal
> AXI/ECC errors.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
