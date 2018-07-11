From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] SCSI results rework preparation part 2
Date: Tue, 10 Jul 2018 22:53:39 -0400
Message-ID: <yq1va9mo53g.fsf@oracle.com>
References: <20180705110140.19545-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705110140.19545-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Thu, 5 Jul 2018 13:01:36 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> As the first part of the preparation work for my scsi results handling
> rework is done, here's the second batch.
>
> The first patch changes the AAC_STAT_GOOD define into an open-coded
> version in aacraid. The other three patches convert the three
> ScsiResult() macros in bfa, lpfc and ncr53c8xx to their open-coded
> equivalen.
>
> This is helpful for subsequent refactoring, as it's easier to identify
> which code parts need more work and Coccinelle Spatches are easier to
> apply.

Applied to 4.19/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
