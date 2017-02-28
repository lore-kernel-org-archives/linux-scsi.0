From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: use div_u64 for 64-bit division
Date: Mon, 27 Feb 2017 22:11:47 -0500
Message-ID: <yq160jvxb4c.fsf@oracle.com>
References: <20170227203159.3272843-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170227203159.3272843-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 27 Feb 2017 21:31:43 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The new debugfs output causes a link error on 32-bit
Arnd> architectures: ERROR: "__aeabi_uldivmod"
Arnd> [drivers/scsi/lpfc/lpfc.ko] undefined!

Arnd> This code is not performance critical, so we can simply use
Arnd> div_u64().

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
