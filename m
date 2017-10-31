From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi/NCR5380: Suppress SDTR and WDTR message logging
Date: Tue, 31 Oct 2017 08:17:23 -0400
Message-ID: <yq11sljecks.fsf@oracle.com>
References: <alpine.LNX.2.00.1710261632460.3@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1710261632460.3@nippy.intranet> (Finn Thain's
        message of "Thu, 26 Oct 2017 16:51:50 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> The 5380 drivers only support asynchronous transfers and the 5380
> controllers only have narrow busses. Hence, the core driver will reject 
> any SDTR and WDTR messages from target devices. Don't log this, it's 
> expected behaviour. Also, fix the off-by-one array indices in the 
> arguments to scmd_printk().

Applied to 4.15/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
