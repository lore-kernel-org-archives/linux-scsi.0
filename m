From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: aacraid: change wait_sem to a completion
Date: Wed, 12 Dec 2018 20:36:07 -0500
Message-ID: <yq1wooegqd4.fsf@oracle.com>
References: <20181210213301.1065510-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210213301.1065510-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 10 Dec 2018 22:32:40 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Prasad B Munirathnam <prasad.munirathnam@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>, Dan Carpenter <dan.carpenter@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The wait_sem member is used like a completion, so we should use the
> respective API. The behavior is unchanged.

Applied to 4.21/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
