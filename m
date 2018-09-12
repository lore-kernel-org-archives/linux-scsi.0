From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: remove unused redundant variable num_chip_names
Date: Tue, 11 Sep 2018 21:03:45 -0400
Message-ID: <yq1bm93y1am.fsf@oracle.com>
References: <20180904143656.3504-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904143656.3504-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 4 Sep 2018 15:36:56 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> Variable num_chip_names is defined but not used, hence it is
> redundant and can be removed.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
