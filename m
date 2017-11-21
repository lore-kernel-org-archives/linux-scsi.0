From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: 3ware: use 64-bit times for FW time sync
Date: Mon, 20 Nov 2017 22:06:52 -0500
Message-ID: <yq1shd8misz.fsf@oracle.com>
References: <20171110155840.1941250-1-arnd@arndb.de>
        <20171110155840.1941250-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110155840.1941250-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 10 Nov 2017 16:58:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The calculation of the number of seconds since Sunday 00:00:00
> overflows in 2106, meaning that we instead will return the seconds
> since Wednesday 06:28:16 afterwards.
>
> Using 64-bit time stamps avoids this slight inconsistency, and the
> deprecated do_gettimeofday(), replacing it with the simpler
> ktime_get_real_seconds().

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
