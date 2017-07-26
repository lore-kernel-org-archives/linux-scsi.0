From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH, RESEND] scsi: lpfc: fix linking against modular NVMe
 support
Date: Wed, 26 Jul 2017 11:08:20 +0200
Message-ID: <20170726090820.GH4039@linux-x5ow.site>
References: <20170721205401.3374331-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170721205401.3374331-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 21, 2017 at 10:53:46PM +0200, Arnd Bergmann wrote:
> I originally sent the patch in March 2013, the day after the broken
                                       ^ 2017?

> +	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
> +	depends on NVME_FC || NVME_FC=n

OK Kconfig is black magic, but X || X=n ? I have no doubt you do the right
thing, I just don't understand it.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
