From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: remove an unecessary NULL check
Date: Tue, 21 Nov 2017 22:59:15 -0500
Message-ID: <yq1k1yjklpo.fsf@oracle.com>
References: <20171107130131.3zohbeoobjxbqmdz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20171107130131.3zohbeoobjxbqmdz@mwanda> (Dan Carpenter's message
        of "Tue, 7 Nov 2017 16:01:32 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> device->scsi3addr[] is an array, not a pointer, so it can't be NULL.
> I've removed the check.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
