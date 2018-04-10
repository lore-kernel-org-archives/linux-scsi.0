From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Correct setting of SAM_STAT_CHECK_CONDITION
Date: Mon, 09 Apr 2018 21:18:56 -0400
Message-ID: <yq1in8z3lkv.fsf@oracle.com>
References: <20180409123922.854-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409123922.854-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Mon, 9 Apr 2018 14:39:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Himanshu Madhani <himanshu.madhani@cavium.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Bart reports that in qla_isr.c's qla2x00_handle_dif_error we're
> wrongly shifting the SAM_STAT_CHECK_CONDITION by one instead of
> directly ORing it onto the SCSI command's result.

Applied to 4.17/scsi-fixes. Thx!

-- 
Martin K. Petersen	Oracle Linux Engineering
