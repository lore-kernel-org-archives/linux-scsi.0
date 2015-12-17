From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] hisi_sas: use platform_get_irq()
Date: Wed, 16 Dec 2015 22:34:04 -0500
Message-ID: <yq18u4tu4sz.fsf@sermon.lab.mkp.net>
References: <1449835401-200442-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449835401-200442-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Fri, 11 Dec 2015 20:03:21 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh@kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> It is preferred that drivers use platform_get_irq() instead of
John> irq_of_parse_and_map(), so replace.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
