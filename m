From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [RESEND 2] scsi: esas2r: use ktime_get_real_seconds()
Date: Fri, 20 Apr 2018 19:34:04 -0400
Message-ID: <yq11sf9h2qb.fsf@oracle.com>
References: <20180420160219.3560091-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420160219.3560091-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 20 Apr 2018 18:02:09 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> do_gettimeofday() is deprecated because of the y2038 overflow.  Here,
> we use the result to pass into a 32-bit field in the firmware, which
> still risks an overflow, but if the firmware is written to expect
> unsigned values, it can at least last until y2106, and there is not
> much we can do about it.
>
> This changes do_gettimeofday() to ktime_get_real_seconds(), which at
> least simplifies the code a bit, and avoids the deprecated
> interface. I'm adding a comment about the overflow to document what
> happens.

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
