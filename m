From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Mark expected switch fall-through
Date: Tue, 18 Jun 2019 20:57:48 -0400
Message-ID: <yq1o92uxugj.fsf@oracle.com>
References: <20190611150219.GA19152@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611150219.GA19152@embeddedor> (Gustavo A. R. Silva's
        message of "Tue, 11 Jun 2019 10:02:19 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> This patch fixes the following warning:
>
> drivers/scsi/mpt3sas/mpt3sas_base.c: In function =E2=80=98_base_update_io=
c_page1_inlinewith_perf_mode=E2=80=99:
> drivers/scsi/mpt3sas/mpt3sas_base.c:4510:6: warning: this statement may f=
all through [-Wimplicit-fallthrough=3D]
>    if (ioc->high_iops_queues) {
>       ^
> drivers/scsi/mpt3sas/mpt3sas_base.c:4530:2: note: here
>   case MPT_PERF_MODE_LATENCY:
>   ^~~~
>
> Warning level 3 was used: -Wimplicit-fallthrough=3D3

Applied to 5.3/scsi-queue, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
