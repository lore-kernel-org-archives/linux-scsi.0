From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx_2: iterator underflow in sym_getsync()
Date: Tue, 30 Jan 2018 21:29:55 -0500
Message-ID: <yq1k1vyg3q4.fsf@oracle.com>
References: <20180125141340.GA7299@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180125141340.GA7299@mwanda> (Dan Carpenter's message of "Thu,
        25 Jan 2018 17:13:40 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org


Dan,

> We wanted to exit the loop with "div" set to zero, but instead, if we
> don't hit the break then "div" is -1 when we finish the loop.  It
> leads to an array underflow a few lines later.

Applied to 4.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
