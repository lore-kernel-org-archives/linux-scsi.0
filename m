From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 sector blacklist
Date: Mon, 09 Apr 2018 22:07:42 -0400
Message-ID: <yq1woxf24r5.fsf@oracle.com>
References: <20180326135651.8193-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180326135651.8193-1-ross.lagerwall@citrix.com> (Ross
        Lagerwall's message of "Mon, 26 Mar 2018 14:56:51 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ross,

> The Windows Server 2016 iSCSI target doesn't work with the Linux
> kernel initiator since the kernel started sending larger requests by
> default, nor does it implement the block limits VPD page. Apply the
> sector limit workaround for these targets.

Applied to 4.17/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
