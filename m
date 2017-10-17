From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] zfcp: fix erp_action use-before-initialize in REC action trace
Date: Mon, 16 Oct 2017 22:46:08 -0400
Message-ID: <yq1k1zu1ogf.fsf@oracle.com>
References: <20171013134007.54534-1-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171013134007.54534-1-maier@linux.vnet.ibm.com> (Steffen
        Maier's message of "Fri, 13 Oct 2017 15:40:07 +0200")
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Steffen,

> v4.10 commit 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN
> recovery") extended accessing parent pointer fields of
> struct zfcp_erp_action for tracing.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
