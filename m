From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: jazz_esp, sun3x_esp: Pass struct device pointer in dma calls
Date: Mon, 12 Mar 2018 22:06:06 -0400
Message-ID: <yq13714g25t.fsf@oracle.com>
References: <S1751076AbeCGG4t/20180307065702Z+42@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <S1751076AbeCGG4t/20180307065702Z+42@vger.kernel.org> (Finn
        Thain's message of "Wed, 07 Mar 2018 17:56:41 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> In jazz_esp and sun3x_esp, the esp_driver_ops methods pass esp->dev
> in dma api calls as if it was a pointer to a struct device. But
> it actually points to a struct platform_device. Fix this.

Applied to 4.17/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
