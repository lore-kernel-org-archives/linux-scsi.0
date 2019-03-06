From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4] scsi: qla2xxx: avoid printf format warning
Date: Wed, 06 Mar 2019 12:54:00 -0500
Message-ID: <yq1k1hbyjlz.fsf@oracle.com>
References: <20190304193917.702601-1-arnd@arndb.de>
        <20190304193917.702601-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-3-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Mar 2019 20:39:10 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <qtran@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Depending on the target architecture and configuration, both
> phys_addr_t and dma_addr_t may be smaller than 'long long', so we get
> a warning when printing either of them using the %llx format string:

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
