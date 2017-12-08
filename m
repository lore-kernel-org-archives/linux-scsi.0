From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: fix type conversion warning
Date: Thu, 07 Dec 2017 19:58:52 -0500
Message-ID: <yq1o9navxv7.fsf@oracle.com>
References: <20171206141444.634681-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171206141444.634681-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 6 Dec 2017 15:14:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> This changes the code back to shost_priv() once more, but encapsulates
> it in an inline function to document the rather unusual way of using
> the private data only as a pointer to the previously allocated
> structure.

Applied to 4.15/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
