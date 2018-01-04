From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix iscsi-related kernel-doc warnings
Date: Wed, 03 Jan 2018 23:11:48 -0500
Message-ID: <yq1373mxny3.fsf@oracle.com>
References: <44a0f532-b1e9-e0cf-4a61-d592a4306f61@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <44a0f532-b1e9-e0cf-4a61-d592a4306f61@infradead.org> (Randy
        Dunlap's message of "Fri, 22 Dec 2017 14:08:27 -0800")
Sender: target-devel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Randy,

> Fix kernel-doc warnings in drivers/scsi/ that are related to iscsi
> support interfaces.
>
> Fixes these kernel-doc warnings: (tested by adding these files to a new
> target.rst documentation file: WIP)

Applied to 4.16/scsi-queue, thanks!

> Cc:	"Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Cc:	linux-scsi@vger.kernel.org
> Cc:	target-devel@vger.kernel.org
> Cc:	Sagi Grimberg <sagi@grimberg.me>
> Cc:	linux-rdma@vger.kernel.org
> Cc:	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc:	"Martin K. Petersen" <martin.petersen@oracle.com>

     ^^^ checkpatch complains about these spaces.

-- 
Martin K. Petersen	Oracle Linux Engineering
