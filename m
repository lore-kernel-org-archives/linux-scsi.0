From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] hisi_sas: some CQ processing fixes
Date: Thu, 05 Jan 2017 18:22:12 -0500
Message-ID: <yq1mvf5jdnf.fsf@oracle.com>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483446290-185084-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 3 Jan 2017 20:24:47 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset fixes some issues related to servicing of the
John> completion queue interrupt.  The major fix is that sensitive
John> hisi_hba structures need to be locked when free'ing a slot.
John> Another modification is that the v2 hw completion queue irq is now
John> serviced with a tasklet, as too much work was being done in the
John> ISR.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
