From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cxgb4i: fix thermal configuration dependencies
Date: Wed, 21 Nov 2018 22:09:57 -0500
Message-ID: <yq14lc995a2.fsf@oracle.com>
References: <20181102153531.1583478-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102153531.1583478-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Nov 2018 16:35:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> I fixed a bug by adding a dependency in the network driver, but that
> fix caused a related bug in the SCSI driver:

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
