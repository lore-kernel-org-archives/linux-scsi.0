From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: turn bfa_mem_{kva,dma}_setup into inline functions
Date: Mon, 21 Nov 2016 22:29:27 -0500
Message-ID: <yq17f7w19bc.fsf@sermon.lab.mkp.net>
References: <20161116151445.3208739-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161116151445.3208739-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 16 Nov 2016 16:14:27 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> These two macros cause lots of warnings with gcc-7:
Arnd> drivers/scsi/bfa/bfa_svc.c: In function 'bfa_fcxp_meminfo':
Arnd> drivers/scsi/bfa/bfa_svc.c:521:103: error: '*' in boolean context,
Arnd> suggest '&&' instead [-Werror=int-in-bool-context]

Arnd> Using inline functions makes them much more readable and avoids
Arnd> the warnings.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
