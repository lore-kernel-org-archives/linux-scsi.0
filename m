From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi_init: fix boolean expression in pqi_device_remove_start
Date: Fri, 04 Jan 2019 01:02:31 -0500
Message-ID: <yq1imz56juw.fsf@oracle.com>
References: <20190103164744.GA16360@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190103164744.GA16360@embeddedor> (Gustavo A. R. Silva's
        message of "Thu, 3 Jan 2019 10:47:44 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Fix boolean expression by using logical AND operator '&&' instead of
> bitwise operator '&'.

Applied to 4.21/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
