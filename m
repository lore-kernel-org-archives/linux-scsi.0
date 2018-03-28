From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][scsi-next] scsi: core: remove redundant assignment to shost->use_blk_mq
Date: Wed, 28 Mar 2018 18:10:31 -0400
Message-ID: <yq1lgebhmw8.fsf@oracle.com>
References: <20180328164142.27201-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328164142.27201-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 28 Mar 2018 17:41:42 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The first assignment to shost->use_blk_mq is redundant as it is
> overwritten by the following statement. Remove this redundant code.

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
