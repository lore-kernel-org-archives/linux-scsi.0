From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla2xxx: Protect access to qpair members with qpair->qp_lock
Date: Tue, 27 Jun 2017 21:32:02 -0400
Message-ID: <yq1bmp8zylp.fsf@oracle.com>
References: <20170623071011.21184-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50100 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbdF1BcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:32:19 -0400
In-Reply-To: <20170623071011.21184-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 23 Jun 2017 09:10:11 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>, Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>


> In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
> qpair->qp_lock but do access members of the qpair before having the lock.
> Re-order the locking sequence to have all read and write access to qpair
> members under the qpair->qp_lock.

Cavium folks, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
