From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: arcmsr: avoid do_gettimeofday
Date: Mon, 22 Jan 2018 19:31:45 -0500
Message-ID: <yq1lggpiff2.fsf@oracle.com>
References: <20180121231308.2169692-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180121231308.2169692-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 22 Jan 2018 00:12:26 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, y2038@lists.linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The arcmsr uses its own implementation of time_to_tm(), along with
> do_gettimeofday() to read the current time. While the algoritm used
> here is fine in principle, it suffers from two problems:

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
