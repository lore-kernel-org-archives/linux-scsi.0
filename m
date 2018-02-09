From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] scsi: NCR53c406a: avoid section mismatch with LTO
Date: Fri, 09 Feb 2018 18:47:41 -0500
Message-ID: <yq1y3k1u3mq.fsf@oracle.com>
References: <20180202131225.1658853-1-arnd@arndb.de>
        <20180202131225.1658853-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-3-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Feb 2018 14:12:16 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Building with link time optimizations produces a false-postive section
> mismatch warning:

Applied to 4.17/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
