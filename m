From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Tue, 16 Oct 2018 17:47:42 -0400
Message-ID: <yq1ftx5sgw1.fsf@oracle.com>
References: <20181016091223.GA19765@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181016091223.GA19765@embeddedor.com> (Gustavo A. R. Silva's
        message of "Tue, 16 Oct 2018 11:12:23 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Add missing break statement in order to prevent the code from falling
> through to case TEST_UNIT_READY.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
