From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: 3w-9xxx: rework lock timeouts
Date: Mon, 20 Nov 2017 22:07:58 -0500
Message-ID: <yq1o9nwmir5.fsf@oracle.com>
References: <20171110155840.1941250-1-arnd@arndb.de>
        <20171110155840.1941250-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110155840.1941250-3-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 10 Nov 2017 16:58:27 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The TW_IOCTL_GET_LOCK ioctl uses do_gettimeofday() to check whether a
> lock has expired. This can misbehave due to a concurrent
> settimeofday() call, as it is based on 'real' time, and it will
> overflow in y2038 on 32-bit architectures, producing unexpected
> results when used across the overflow time.
>
> This changes it to using monotonic time, using ktime_get() to simplify
> the code.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
