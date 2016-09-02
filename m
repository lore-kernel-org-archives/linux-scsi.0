From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: constify sr_pm_ops structure
Date: Fri, 02 Sep 2016 07:02:55 -0400
Message-ID: <yq14m5ytvhc.fsf@sermon.lab.mkp.net>
References: <1472415458-430-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472415458-430-1-git-send-email-Julia.Lawall@lip6.fr> (Julia
        Lawall's message of "Sun, 28 Aug 2016 22:17:38 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jens Axboe <axboe@kernel.dk>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Julia" == Julia Lawall <Julia.Lawall@lip6.fr> writes:

Julia> sr_pm_ops, of type struct dev_pm_ops, is never modified, so
Julia> declare it as const.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
