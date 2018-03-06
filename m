From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: clarify mmio pointer types
Date: Tue, 06 Mar 2018 13:09:15 -0500
Message-ID: <yq1zi3lqdo4.fsf@oracle.com>
References: <20180301130729.3278022-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301130729.3278022-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 1 Mar 2018 14:07:07 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The newly added code mixes up phys_addr_t/resource_size_t with dma_addr_t
> and void pointers, as seen from these compiler warning:

Applied to 4.17/scsi-queue. Thanks for fixing this up!

-- 
Martin K. Petersen	Oracle Linux Engineering
