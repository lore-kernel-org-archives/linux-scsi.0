From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cxlflash: Select IRQ_POLL
Date: Mon, 08 May 2017 22:09:52 -0400
Message-ID: <yq160hasrv3.fsf@oracle.com>
References: <1494027107-11234-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494027107-11234-1-git-send-email-linux@roeck-us.net> (Guenter
        Roeck's message of "Fri, 5 May 2017 16:31:47 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Manoj N . Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R . Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Guenter,

> The driver now uses IRQ_POLL and needs to select it to avoid the following
> build error.

Applied to 4.12/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
