From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: avoid unused-function warning
Date: Sat, 01 Jul 2017 17:15:33 -0400
Message-ID: <yq1lgo7voy2.fsf@oracle.com>
References: <20170630161056.30630-1-arnd@arndb.de>
        <20170630161056.30630-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170630161056.30630-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 30 Jun 2017 18:10:40 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Quinn Tran <quinn.tran@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Darren Trapp <darren.trapp@cavium.com>, Anil Gurumurthy <anil.gurumurhty@cavium.com>, Duane Grigsby <duane.grigsby@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> When NVMe support is disabled, we get a couple of harmless warnings:
>
> drivers/scsi/qla2xxx/qla_nvme.c:667:13: error: 'qla_nvme_unregister_remote_port' defined but not used [-Werror=unused-function]
> drivers/scsi/qla2xxx/qla_nvme.c:634:13: error: 'qla_nvme_abort_all' defined but not used [-Werror=unused-function]
> drivers/scsi/qla2xxx/qla_nvme.c:604:12: error: 'qla_nvme_wait_on_rport_del' defined but not used [-Werror=unused-function]
>
> This replaces the preprocessor checks in the code with equivalent
> compiler conditionals, which lets gcc drop the unused functions
> without warning, and is nicer to read.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
