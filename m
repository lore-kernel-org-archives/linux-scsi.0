From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][next] scsi: arcmsr: remove redundant check for secs < 0
Date: Mon, 11 Dec 2017 21:37:47 -0500
Message-ID: <yq1y3m8r7r8.fsf@oracle.com>
References: <20171209003414.17332-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171209003414.17332-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 9 Dec 2017 00:34:14 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The check for secs being less than zero is redundant for two reasons.
> Firstly, secs is unsigned so the check is always going to be false.
> Secondly, if secs was signed the proceeding calculation of secs is
> never going to be negative.  Hence we can remove this redundant check
> and day and secs re-adjustment.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
