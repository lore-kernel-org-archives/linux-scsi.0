From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: myrs: only build on little-endian platforms
Date: Mon, 05 Nov 2018 22:36:30 -0500
Message-ID: <yq14lcu7u81.fsf@oracle.com>
References: <20181102154740.2011289-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102154740.2011289-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Nov 2018 16:47:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Reading throught the new driver, I noticed that this cannot work on
> big-endian CPUs, and the old DAC960 had exactly the same behavior.
>
> To document this for the future, add a Kconfig dependency that prevents it
> from being included in big-endian kernels.  Since the hardware is really
> old and we never had a working driver on it for big-endian platforms,
> it's unlikely to make a difference to users.

Applied to 4.20/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
