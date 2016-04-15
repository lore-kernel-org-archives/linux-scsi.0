From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] hisi_sas: v2 hw SATA fixes
Date: Thu, 14 Apr 2016 22:20:01 -0400
Message-ID: <yq14mb3txym.fsf@sermon.lab.mkp.net>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Fri, 8 Apr 2016 17:23:10 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces SATA support fixes for the HiSilicon v2
John> hw SAS controller.

John> Fixes include: - attach issue for SATA disk attached through
John> expander - intermittent issue for directly attaching multiple SATA
John> disks - add support for directly attaching SATA disk to phy index
John> 4+ - ITCT config issue

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
