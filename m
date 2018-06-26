From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: use 64-bit timestamps consistently
Date: Tue, 26 Jun 2018 11:59:08 -0400
Message-ID: <yq1woul4jzn.fsf@oracle.com>
References: <20180618153004.1808419-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618153004.1808419-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 18 Jun 2018 17:29:51 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <jsmart2021@gmail.com>, Jens Axboe <axboe@kernel.dk>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The get_seconds() helper returns an 'unsigned long' value, which can
> overflow on 32-bit architectures. Since the interface we pass it into
> already uses a 64-bit type, we can just use ktime_get_real_seconds()
> instead.
>
> While we generally prefer local timestamps in CLOCK_MONOTONIC format
> (ktime_get_seconds), this keeps using the CLOCK_REALTIME version in
> order to maintain compatibility with existing code.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
