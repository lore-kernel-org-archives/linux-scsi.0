From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] libsas: Some minor improvements and tidy-up
Date: Mon, 15 Apr 2019 19:33:24 -0400
Message-ID: <yq1v9zehmij.fsf@oracle.com>
References: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1555059478-36224-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 12 Apr 2019 16:57:51 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com, chenxiang66@hisilicon.com, luojiaxing@huawei.com
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset introduces some minor improvements and tidy-up, including:
> - fix PHY info in sysfs for PHY events
> - min pathway rate programming improvement
> - some other tidy-up and neatening

Applied to 5.2/scsi-queue, thanks!

One thing that always bugged me is the ambiguous "ex" prefix for many
libsas log messages. And in a way, your patch #3 makes things worse by
replacing the more descriptive "Expander" with "ex". It does make things
more consistent, though.

I'd really like to see all the libsas messages be cleaned up with a
sensible prefix and a consistent format where possible.

-- 
Martin K. Petersen	Oracle Linux Engineering
