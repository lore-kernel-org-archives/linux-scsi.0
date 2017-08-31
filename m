From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: add missing includes for qla_isr
Date: Wed, 30 Aug 2017 22:09:44 -0400
Message-ID: <yq1inh4xzbr.fsf@oracle.com>
References: <20170830131231.7934-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170830131231.7934-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 30 Aug 2017 15:12:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Since commit 7401bc18d1ee ("scsi: qla2xxx: Add FC-NVMe command handling")
> we make use of 'struct nvmefc_fcp_req' in qla24xx_nvme_iocb_entry() without
> including linux/nvme-fc-driver.h where it is defined.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
