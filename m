From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: debug: remove jiffies_to_timespec
Date: Wed, 29 Nov 2017 00:01:40 -0500
Message-ID: <yq1k1y9he4r.fsf@oracle.com>
References: <20171127113647.2352914-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127113647.2352914-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 27 Nov 2017 12:36:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, Bart Van Assche <bart.vanassche@wdc.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> There is no need to go through an intermediate timespec to convert to
> ktime_t when we just want a simple multiplication. This gets rid of
> one of the few users of jiffies_to_timespec, which I hope to remove as
> part of the y2038 cleanup.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
