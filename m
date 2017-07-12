From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: pass an error pointer to fc_disc_error()
Date: Wed, 12 Jul 2017 17:25:42 -0400
Message-ID: <yq1wp7djqjt.fsf@oracle.com>
References: <20170712073022.e24r3iad7jqxarn6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170712073022.e24r3iad7jqxarn6@mwanda> (Dan Carpenter's message
        of "Wed, 12 Jul 2017 10:30:22 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Robert Love <rml@tech9.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> This patch is basically to silence a static checker warning.
>
>     drivers/scsi/libfc/fc_disc.c:326 fc_disc_error()
>     warn: passing a valid pointer to 'PTR_ERR'
>
> It doesn't affect runtime because it treats -ENOMEM and a valid pointer
> the same.  But the documentation says we should be passing an error
> pointer.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
