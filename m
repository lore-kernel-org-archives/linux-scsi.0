From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qlogicpti: Mark expected switch fall-throughs
Date: Wed, 07 Aug 2019 21:33:31 -0400
Message-ID: <yq1imr8e904.fsf@oracle.com>
References: <20190729110345.GA2603@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729110345.GA2603@embeddedor> (Gustavo A. R. Silva's message
        of "Mon, 29 Jul 2019 06:03:45 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Mark switch cases where we are expecting to fall through.
>
> This patch fixes the following warnings (Building: sparc defconfig):

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
