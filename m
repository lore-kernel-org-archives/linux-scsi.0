From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: myrs: avoid stack overflow warning
Date: Mon, 05 Nov 2018 22:36:14 -0500
Message-ID: <yq18t267u8h.fsf@oracle.com>
References: <20181102154426.1951776-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102154426.1951776-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Nov 2018 16:44:13 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hannes Reinecke <hare@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Putting a 1024 byte data structure on the stack is generally a bad idea.
> On 32-bit systems, it also triggers a compile-time warning when building
> with -Og:

Applied to 4.20/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
