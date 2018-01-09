From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][scsi-next] scsi: aacraid: remove redundant setting of variable c
Date: Mon, 08 Jan 2018 21:50:57 -0500
Message-ID: <yq1wp0roicu.fsf@oracle.com>
References: <20180105153106.17605-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180105153106.17605-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 5 Jan 2018 15:31:06 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> A previous commit no longer stores the contents of c, so we now have a
> situation where c is being updated but the value is never read. Clean
> up the code by removing the now redundant setting of variable c.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
