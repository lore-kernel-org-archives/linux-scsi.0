From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pm80xx: fix spelling mistake "UNSORPORTED" -> "SUPPORTED"
Date: Mon, 28 May 2018 21:32:01 -0400
Message-ID: <yq1a7sj457y.fsf@oracle.com>
References: <20180526144218.9891-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180526144218.9891-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 26 May 2018 15:42:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Trivial fix to spelling mistake in pm8001_printk message text; also I
> believe NOT_UNSUPPORTED should probably be NOT_SUPPORTED. Also fix the
> indent of the pm8001_printk statement.

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
