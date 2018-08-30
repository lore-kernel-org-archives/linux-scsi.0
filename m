From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: raid_attrs: fix unused variable warning
Date: Thu, 30 Aug 2018 07:23:53 -0400
Message-ID: <yq14lfc5c8m.fsf@oracle.com>
References: <20180813222716.757523-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180813222716.757523-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 14 Aug 2018 00:27:10 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> I ran into a new warning on randconfig kernels:
>
> drivers/scsi/raid_class.c: In function 'raid_match':
> drivers/scsi/raid_class.c:64:24: error: unused variable 'i' [-Werror=unused-variable]
>
> This looks like a very old problem that for some reason was very
> hard to run into, but it is very easy to fix, by replacing the
> incorrect #ifdef with a simpler IS_ENABLED() check.

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
