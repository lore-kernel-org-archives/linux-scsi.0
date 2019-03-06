From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Wed, 06 Mar 2019 12:34:26 -0500
Message-ID: <yq1y35rzz31.fsf@oracle.com>
References: <1551455797.3334.6.camel@linux.ibm.com>
        <20190301160806.16099-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190301160806.16099-1-e.velu@criteo.com> (Erwan Velu's message
        of "Fri, 1 Mar 2019 17:08:06 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Erwan,

> When the HARDWARE_ERROR/0x3e/0x1 case is triggered, the logical volume
> is offlined.  When reading the kernel log, the reason why the device
> got offlined isn't reported to the user.  This situation makes
> difficult for admins to estimate the root cause of the issue they
> analize.

Applied to 5.1/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
