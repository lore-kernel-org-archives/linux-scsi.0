From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: wd33c93: Mark expected swich fall-through
Date: Wed, 07 Aug 2019 21:38:57 -0400
Message-ID: <yq1a7cke8r2.fsf@oracle.com>
References: <20190729210313.GA5896@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729210313.GA5896@embeddedor> (Gustavo A. R. Silva's message
        of "Mon, 29 Jul 2019 16:03:13 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Mark switch cases where we are expecting to fall through.
>
> This patch fixes the following warning (Building: m68k):
>
> drivers/scsi/wd33c93.c: In function =E2=80=98round_4=E2=80=99:
> drivers/scsi/wd33c93.c:1856:11: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>    case 2: ++x;
>            ^~~

Applied to 5.4/scsi-queue, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
