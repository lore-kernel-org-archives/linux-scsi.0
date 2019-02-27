From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Add missing breaks in switch statements
Date: Wed, 27 Feb 2019 09:37:29 -0500
Message-ID: <yq1lg219u1i.fsf@oracle.com>
References: <20190215215414.GA10944@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190215215414.GA10944@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 15 Feb 2019 15:54:14 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Fix the following warnings by adding the proper missing breaks:
>
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function =E2=80=98_base_display_O=
EMs_branding=E2=80=99:
> drivers/scsi/mpt3sas/mpt3sas_base.c:3548:4: warning: this statement may f=
all thr

Applied to 5.1/scsi-queue, thanks.

--=20
Martin K. Petersen	Oracle Linux Engineering
