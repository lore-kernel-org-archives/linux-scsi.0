From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sas: scsi_queue_work can fail, so make callers aware
Date: Tue, 27 Jun 2017 21:28:50 -0400
Message-ID: <yq1fuekzyr1.fsf@oracle.com>
References: <20170614115243.17776-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24156 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdF1B3D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:29:03 -0400
In-Reply-To: <20170614115243.17776-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 14 Jun 2017 13:52:43 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, wangyijing@huawei.com


Johannes,

> libsas uses scsi_queue_work() to queue it's internal event
> notifications. scsi_queue_work() can return -EINVAL if the work queue
> doesn't exist and it does call queue_work() which can return false if
> the work is already queued.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
