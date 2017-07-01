From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla2xxx: Protect access to qpair members with qpair->qp_lock
Date: Sat, 01 Jul 2017 16:50:19 -0400
Message-ID: <yq1wp7rx4ok.fsf@oracle.com>
References: <20170623071011.21184-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623071011.21184-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 23 Jun 2017 09:10:11 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
> qpair->qp_lock but do access members of the qpair before having the lock.
> Re-order the locking sequence to have all read and write access to qpair
> members under the qpair->qp_lock.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
