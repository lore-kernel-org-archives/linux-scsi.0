From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] scsi: qedf: use correct strncpy() size
Date: Fri, 09 Feb 2018 18:36:53 -0500
Message-ID: <yq1bmgxvip6.fsf@oracle.com>
References: <20180202131225.1658853-1-arnd@arndb.de>
        <20180202131225.1658853-7-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-7-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Feb 2018 14:12:20 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Saurav Kashyap <saurav.kashyap@cavium.com>, "Dupuis, Chad" <chad.dupuis@cavium.com>, Arun Easi <arun.easi@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> gcc-8 warns during link-time optimization that the strncpy() call
> passes the size of the source buffer rather than the destination:

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
