From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: remove some redundant variables
Date: Thu, 02 Aug 2018 16:23:50 -0400
Message-ID: <yq1zhy4y0tl.fsf@oracle.com>
References: <20180801145841.5877-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801145841.5877-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 1 Aug 2018 15:58:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Matthew Wilcox <willy@infradead.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Variables scriptb0 and dp_sgmin are being assigned but are never
> used hence they are redundant and can be removed.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
