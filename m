From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: remove redundant check to see if request_size is less than zero
Date: Mon, 08 May 2017 22:18:00 -0400
Message-ID: <yq1wp9qrcx3.fsf@oracle.com>
References: <20170503162901.3623-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170503162901.3623-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 3 May 2017 17:29:01 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The 2nd check to see if request_size is less than zero is redundant
> because the first check takes error exit path on this condition. So,
> since it is redundant, remove it.

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
