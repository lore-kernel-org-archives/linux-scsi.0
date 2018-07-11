From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: switch to scsi-mq by default
Date: Tue, 10 Jul 2018 22:52:21 -0400
Message-ID: <yq1d0vupjq2.fsf@oracle.com>
References: <20180704085356.10888-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704085356.10888-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 4 Jul 2018 10:53:56 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ming Lei <tom.leiming@gmail.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> It has been more than one year since we tried to change the default
> from legacy to multi queue in SCSI with commit c279bd9e406 ("scsi:
> default to scsi-mq"). But due to issues with suspend/resume and
> performance problems it had been reverted again with commit
> cbe7dfa26eee ("Revert "scsi: default to scsi-mq"").
>
> In the meantime there have been a substantial amount of performance
> improvements and suspend/resume got fixed as well, thus we can
> re-enable scsi-mq without a significant performance penalty.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
