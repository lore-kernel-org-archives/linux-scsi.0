From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][V2] scsi: qedf: remove memset/memcpy to nfunc and use func instead
Date: Thu, 18 Apr 2019 20:33:21 -0400
Message-ID: <yq11s1ydeb2.fsf@oracle.com>
References: <20190412094829.15868-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412094829.15868-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 12 Apr 2019 10:48:29 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Currently the qedf_dbg_* family of functions can overrun the end of
> the source string if it is less than the destination buffer length
> because of the use of a fixed sized memcpy. Remove the memset/memcpy
> calls to nfunc and just use func instead as it is always a null
> terminated string.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
