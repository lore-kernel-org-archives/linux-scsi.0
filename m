From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH B] scsi: fdomain: fix building pcmcia front-end
Date: Mon, 22 Jul 2019 22:07:01 -0400
Message-ID: <yq1pnm1sdve.fsf@oracle.com>
References: <20190722121908.163702-1-arnd@arndb.de>
        <20190722121908.163702-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190722121908.163702-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 22 Jul 2019 14:19:08 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@zary.sk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Move all of SCSI_LOWLEVEL_PCMCIA inside of the existing SCSI_LOWLEVEL
> section. Very few people use the PCMCIA support these days, and they
> likely don't mind having to turn on SCSI_LOWLEVEL as well. This way we
> avoid the link error and get a more sensible structure.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
