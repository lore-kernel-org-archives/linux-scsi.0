From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][next] scsi: hpsa: fix an uninitialized read and dereference of pointer dev
Date: Wed, 29 May 2019 21:55:42 -0400
Message-ID: <yq18suozowx.fsf@oracle.com>
References: <20190522083903.18849-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522083903.18849-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 22 May 2019 09:39:03 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Currently the check for a lockup_detected failure exits via the label
> return_reset_status that reads and dereferences an uninitialized
> pointer dev.  Fix this by ensuring dev is inintialized to null.

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
