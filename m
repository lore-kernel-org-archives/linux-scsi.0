From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] hisi_sas: device id/IPTT collision workaround
Date: Fri, 15 Apr 2016 16:56:27 -0400
Message-ID: <yq1ega6pp50.fsf@sermon.lab.mkp.net>
References: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460727398-102091-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Fri, 15 Apr 2016 21:36:35 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces a workaround to a hw quirk in the
John> HiSilicon SAS controller v2 hw.

John> The quirk is as follows: When a SATA and SAS frame arrives at the
John> host at the same time the frames may be swapped under this
John> condition: SATA device id bit [10:0] == SAS frame IPTT bit [10:0]
John> The workaround is to ensure these 2 values never match. The
John> workaround algorithm is as follows: - SATA device id bit0 always 0
John> - SATA IPTT has no restriction - SAS IPTT bit0 always 1 - SAS
John> device id has no restriction

John> The major restriction of this workaround is the SAS IPTT range is
John> halved, but this should be ok as testing has shown that even using
John> half the IPTT range does not affect performance.

Applied to 4.7/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
