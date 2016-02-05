From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] hisi_sas: use Unified Device Properties API
Date: Thu, 04 Feb 2016 22:22:33 -0500
Message-ID: <yq1vb63g7t2.fsf@sermon.lab.mkp.net>
References: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
	<1454523970-118251-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454523970-118251-2-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Thu, 4 Feb 2016 02:26:08 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> The hisi_sas driver is required to support both device tree and
John> ACPI. The scanning of the device properties now uses the Unified
John> Device Properties API, which serves both OF and ACPI.

Series applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
