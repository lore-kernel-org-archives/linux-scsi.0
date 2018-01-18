From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [RESEND] scsi: fnic: use 64-bit timestamps
Date: Wed, 17 Jan 2018 21:53:51 -0500
Message-ID: <yq1fu73ri68.fsf@oracle.com>
References: <20180117151708.3359303-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117151708.3359303-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 17 Jan 2018 16:16:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vasyl Gomonovych <gomonovych@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> struct timespec is deprecated since it overflows in 2038 on 32-bit
> architectures, so we should use timespec64 consistently.
>
> I'm slightly adapting the format strings here, to make sure we
> print the nanoseconds with the correct number of leading zeroes.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
