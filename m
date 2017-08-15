From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sym53c8xx: Avoid undefined behaviour in drivers/scsi/sym53c8xx_2/sym_hipd.c:762
Date: Mon, 14 Aug 2017 23:07:20 -0400
Message-ID: <yq1d17xwmtz.fsf@oracle.com>
References: <20170810190849.GA12659@p100.box>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20170810190849.GA12659@p100.box> (Helge Deller's message of
        "Thu, 10 Aug 2017 21:08:49 +0200")
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Helge,

> On parisc I see this UBSAN warning with a sym53c896:
>
>  UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
>  index -1903078336 is out of range for type 'u32 [7]'
>
> Avoid this warning by switching to dev64_ul().

Applied to 4.14/scsi-queue. Thank you, Helge!

-- 
Martin K. Petersen	Oracle Linux Engineering
