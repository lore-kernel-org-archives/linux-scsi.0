From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] drivers/scsi/cxgbi: using ccflags-y instead of EXTRA_CFLAGS
 in Kbuild
Date: Sun, 07 Apr 2013 11:17:29 +0800
Message-ID: <5160E549.4080702@asianux.com>
References: <50F15A35.4000400@asianux.com> <50FB9A33.2090204@asianux.com> <51077BB3.2010809@asianux.com> <512ECDDC.2020607@asianux.com> <512EF43D.1070805@asianux.com> <512EFA91.5050101@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512EFA91.5050101@asianux.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, Greg KH <gregkh@linuxfoundation.org>, kxie@chelsio.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Maintainers:

  please help check it when you have time.

  thanks.

gchen.

On 2013=C4=EA02=D4=C228=C8=D5 14:34, Chen Gang wrote:
>=20
>   need using ccflags-y instead of EXTRA_CFLAGS
>     can reference scripts/checkpatch.pl (1755..1766)
>=20
>   when make EXTRA_CFLAGS=3D-W, the compiling issue will be occured.
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/scsi/cxgbi/cxgb3i/Kbuild |    2 +-
>  drivers/scsi/cxgbi/cxgb4i/Kbuild |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cx=
gb3i/Kbuild
> index 6f095e2..961a12f 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
> +ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
> =20
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI) +=3D cxgb3i.o
> diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cx=
gb4i/Kbuild
> index 8290cda..3745864 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
> +ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
> =20
>  obj-$(CONFIG_SCSI_CXGB4_ISCSI) +=3D cxgb4i.o
>=20


--=20
Chen Gang

Asianux Corporation
