From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxlflash: Fix an error handling path in 'cxlflash_disk_attach()'
Date: Tue, 15 Aug 2017 22:11:50 -0400
Message-ID: <yq1378stg61.fsf@oracle.com>
References: <20170815201814.12929-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170815201814.12929-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Tue, 15 Aug 2017 22:18:14 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

> 'rc' is known to be 0 at this point.
> If 'create_context()' fails, returns -ENOMEM instead of 0 which means
> success.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
