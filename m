From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: address UBSAN warning regression
Date: Wed, 29 Nov 2017 00:07:48 -0500
Message-ID: <yq1fu8xhduj.fsf@oracle.com>
References: <20171128132536.3037571-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128132536.3037571-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 28 Nov 2017 14:25:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Meelis Roos <mroos@linux.ee>, Dave Carroll <david.carroll@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> As reported by Meelis Roos, my previous patch causes an incorrect
> calculation of the timeout, through an undefined signed integer
> overflow:

Applied to 4.15/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
