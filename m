From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] NCR5380: Return false instead of NULL
Date: Mon, 05 Nov 2018 22:48:27 -0500
Message-ID: <yq1r2fy6f3o.fsf@oracle.com>
References: <2e765651c37d951fb424eb966e1a91ff08c8391b.1540367133.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2e765651c37d951fb424eb966e1a91ff08c8391b.1540367133.git.fthain@telegraphics.com.au>
        (Finn Thain's message of "Wed, 24 Oct 2018 18:45:33 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> I overlooked this statement when I recently converted the function result
> type from struct scsi_cmnd * to bool. No change to object code.

Applied to 4.20/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
