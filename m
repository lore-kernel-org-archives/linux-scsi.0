From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] scsi: qedi: fix building with LTO
Date: Tue, 06 Feb 2018 20:24:08 -0500
Message-ID: <yq17erp1tjb.fsf@oracle.com>
References: <20180202131225.1658853-1-arnd@arndb.de>
        <20180202131225.1658853-6-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-6-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Feb 2018 14:12:19 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, Tomer Tayar <Tomer.Tayar@cavium.com>, "David S. Miller" <davem@davemloft.net>, Ariel Elior <Ariel.Elior@cavium.com>, Arun Easi <arun.easi@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> When link-time optimizations are enabled, qedi fails to build because
> of mismatched prototypes:

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
