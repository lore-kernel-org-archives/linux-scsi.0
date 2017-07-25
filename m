From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/22] gcc-7 -Wformat-* warnings
Date: Mon, 24 Jul 2017 21:48:22 -0400
Message-ID: <yq1fudl2snt.fsf@oracle.com>
References: <20170714120720.906842-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170714120720.906842-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 14 Jul 2017 14:06:52 +0200")
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org, netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> This series addresses all warnings that gcc-7 introduces for
> -Wformat-overflow= and turns off the -Wformat-truncation by default
> (they remain enabled with "make W=1").

Applied the SCSI patches. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
