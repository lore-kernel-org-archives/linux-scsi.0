From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csi: hpsa: Fix =?utf-8?Q?configured=5Flogical=5Fdrive?=
 =?utf-8?Q?=5Fcount=C2=B7check?=
Date: Mon, 16 Oct 2017 23:15:56 -0400
Message-ID: <yq1y3oazcpf.fsf@oracle.com>
References: <1508182082-11828-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508182082-11828-1-git-send-email-chris.gekas@gmail.com>
        (Christos Gkekas's message of "Mon, 16 Oct 2017 20:28:02 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christos,

> Check whether configured_logical_drive_count is less than
> 255. Previous check was always evaluating to true as this variable is
> defined as u8.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
