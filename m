From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fnic: use 64-bit timestamps
Date: Mon, 20 Nov 2017 21:30:49 -0500
Message-ID: <yq1mv3gnz1i.fsf@oracle.com>
References: <20171107104305.2952640-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107104305.2952640-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 7 Nov 2017 11:41:39 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> struct timespec is deprecated since it overflows in 2038 on 32-bit
> architectures, so we should use timespec64 consistently.
>
> I'm slightly adapting the format strings here, to make sure we print
> the nanoseconds with the correct number of leading zeroes.

Satish: Please review/test. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
