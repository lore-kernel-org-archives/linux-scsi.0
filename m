From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/8] hisi_sas: debugfs support
Date: Fri, 04 Jan 2019 00:54:37 -0500
Message-ID: <yq1wonl6k82.fsf@oracle.com>
References: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545235006-151716-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 19 Dec 2018 23:56:38 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset adds debugfs support for capturing driver state for
> particular times when the HW has malfunctioned (and we must reset the HW).
>
> Every controller HW version has had bugs. These bugs have been very
> painful to debug. One useful tool to debug these is being able to capture
> and export HW registers and driver control structures at point of failure.
>
> This feature has been maintained out-of-tree for some time, so add it now.

Applied to 4.22/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
