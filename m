From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sun3_scsi: Mark expected switch fall-throughs
Date: Wed, 07 Aug 2019 21:35:05 -0400
Message-ID: <yq1ef1we8xi.fsf@oracle.com>
References: <20190729143007.GA8067@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729143007.GA8067@embeddedor> (Gustavo A. R. Silva's message
        of "Mon, 29 Jul 2019 09:30:07 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Mark switch cases where we are expecting to fall through.
>
> This patch fixes the following warnings:
>
> drivers/scsi/sun3_scsi.c: warning: this statement may fall through
> [-Wimplicit-fallthrough=]:  => 399:9, 403:9

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
