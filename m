From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: avoid an unused function warning
Date: Fri, 25 Aug 2017 18:27:40 -0400
Message-ID: <yq1bmn35llv.fsf@oracle.com>
References: <20170824231016.1843118-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824231016.1843118-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 25 Aug 2017 01:09:59 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The only reference to lpfc_nvmet_replenish_context() is inside of an
> #ifdef, leading to a harmless warning when CONFIG_NVME_TARGET_FC is
> disabled:

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
