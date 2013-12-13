From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 2/3] drivers: message: Mark function
 mptscsih_quiesce_raid() as static in mptspi.c
Date: Fri, 13 Dec 2013 01:00:55 -0800
Message-ID: <20131213090055.GI4386@leaf>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
 <ca5bfbf90534e77ef7333f36286dcb36c563b368.1386914148.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ca5bfbf90534e77ef7333f36286dcb36c563b368.1386914148.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2013 at 11:36:54AM +0530, Rashika Kheria wrote:
> This patch marks the function mptscsih_quiesce_raid() as static in
> fusion/mptspi.c because it is not used outside this function.
>=20
> Thus, it also eliminates the following warning in fusion/mptspi.c:
> drivers/message/fusion/mptspi.c:624:1: warning: no previous prototype=
 for =E2=80=98mptscsih_quiesce_raid=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/message/fusion/mptspi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion=
/mptspi.c
> index 5653e50..ed8de0a 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -620,7 +620,7 @@ static void mptspi_read_parameters(struct scsi_ta=
rget *starget)
>  	spi_width(starget) =3D (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
>  }
> =20
> -int
> +static int
>  mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8=
 id)
>  {
>  	MPT_ADAPTER	*ioc =3D hd->ioc;
> --=20
> 1.7.9.5
>=20
