From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/5] libsas: Some logging tidy-up
Date: Thu, 15 Nov 2018 14:40:06 -0500
Message-ID: <yq1k1leb04p.fsf@oracle.com>
References: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542277232-135789-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 15 Nov 2018 18:20:27 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset presents some logging tidy-up, namely removing the
> printk wrappers and using pr_XXX() instead.
>
> In addition, some log levels are revised, as previous levels
> (generally debug) were too low.
>
> Finally a referece to "pci" is removed from a log, and unreferenced
> dump files are deleted.

Applied to 4.21/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
