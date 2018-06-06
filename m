From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: aic79xx: fix potential null pointer dereference on ahd
Date: Tue, 05 Jun 2018 21:38:37 -0400
Message-ID: <yq1vaawelsy.fsf@oracle.com>
References: <20180531123117.32118-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531123117.32118-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 31 May 2018 13:31:17 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> If AHD_DEBUG is enabled and ahd_platform_alloc fails then ahd is set
> to null and the debug printk dereferences ahd when passing it to
> ahd_name.  Fix this by moving the debug printk to before the call to
> ahd_platform_alloc where ahd is not null at that point.

Applied to 4.18/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
