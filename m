From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] scsi: aic7xxx: Fix build using bare-metal toolchain
Date: Thu, 30 Aug 2018 07:41:58 -0400
Message-ID: <yq1efeg3wu1.fsf@oracle.com>
References: <20180829170015.7729-1-semen.protsenko@linaro.org>
        <20180829170015.7729-3-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829170015.7729-3-semen.protsenko@linaro.org> (Sam
        Protsenko's message of "Wed, 29 Aug 2018 20:00:15 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org


Sam,

> Bare-metal toolchains don't define __linux__, so aic7xxx build with
> bare-metal toolchain is broken. This driver codebase used to be
> partially shared with FreeBSD, but these days there is no point in
> keeping the compatibility around. So let's just drop FreeBSD related
> code and get rid of __linux__ checking in order to fix the build using
> bare-metal toolchains.

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
