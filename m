From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][V3] scsi: cxgbi: remove redundant __kfree_skb call on skb and free cst->atid
Date: Fri, 12 Apr 2019 20:06:01 -0400
Message-ID: <yq1k1fykbva.fsf@oracle.com>
References: <20190412083301.25503-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412083301.25503-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 12 Apr 2019 09:33:01 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The error return path via label rel_resource checks for a non-null skb
> before free'ing it.  However, skb is always null at this exit path, so
> the null check and the free are redundant and can be removed.
> Removing this allows the original goto's to rel_resource to be cleaned
> up; the first can be replaced by a return of -EINVAL, the second can
> be replaced by a more appropriate -ENOMEM return and fix a memory leak
> by freeing csk->atid.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
