From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] aic7xxx: fix order of arguments in function prototype
Date: Wed, 19 Apr 2017 22:17:46 -0400
Message-ID: <yq1bmrrrfed.fsf@oracle.com>
References: <20170408172842.20226-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170408172842.20226-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 8 Apr 2017 18:28:42 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> The vendor/device and subvendor/subdevice arguments to the function
> prototype ahc_9005_subdevinfo_valid are in the wrong order and need to
> be swapped to fix this.  Detected with PVS-Studio studio.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
