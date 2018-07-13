From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [RESEND] snic: fix printing time intervals
Date: Thu, 12 Jul 2018 23:02:23 -0400
Message-ID: <yq1a7qvj0sg.fsf@oracle.com>
References: <20180711123752.773163-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711123752.773163-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 11 Jul 2018 14:37:37 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> We don't want to use 'struct timespec' because of the y2038 overflow
> problem. The overflow is not actually an issue here, but it's easy to
> replace with 'timespec64' for consistency. However, it's worth pointing
> out that nanosecond values have nine digits, not eight or ten, so I'm
> fixing the format strings accordingly as well.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
