From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: libfc: pass an error pointer to fc_disc_error()
Date: Wed, 12 Jul 2017 09:54:14 +0200
Message-ID: <20170712075414.GB4115@linux-x5ow.site>
References: <20170712073022.e24r3iad7jqxarn6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170712073022.e24r3iad7jqxarn6@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Robert Love <rml@tech9.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2017 at 10:30:22AM +0300, Dan Carpenter wrote:
> This patch is basically to silence a static checker warning.
> 
>     drivers/scsi/libfc/fc_disc.c:326 fc_disc_error()
>     warn: passing a valid pointer to 'PTR_ERR'
> 
> It doesn't affect runtime because it treats -ENOMEM and a valid pointer
> the same.  But the documentation says we should be passing an error
> pointer.

Acked-by: Johannes Thumshirn <jth@kernel.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
