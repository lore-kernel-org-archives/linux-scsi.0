From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: use proper format string for dma_addr_t
Date: Mon, 27 Feb 2017 22:11:59 -0500
Message-ID: <yq11sujxb40.fsf@oracle.com>
References: <20170227203726.3420612-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170227203726.3420612-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 27 Feb 2017 21:37:12 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> dma_addr_t may be either u32 or u64, depending on the kernel
Arnd> configuration, and we get a warning for the 32-bit case:

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
