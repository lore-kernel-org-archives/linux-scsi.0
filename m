From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla4xxx: remove redundant check on drvr_wait
Date: Fri, 28 Sep 2018 02:30:51 -0400
Message-ID: <yq18t3mb0bo.fsf@oracle.com>
References: <20180926130848.30645-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926130848.30645-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 26 Sep 2018 14:08:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The check for a non-zero drvr_wait is redundant as the same check is
> performed earlier in the outer while loop, the inner check will always
> be true if we reached this point inside the while loop.  Remove the
> redundant if check.

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
