From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/3] drivers: message: Mark function
 mpt_SoftResetHandler() as static in mptbase.c
Date: Fri, 13 Dec 2013 00:59:50 -0800
Message-ID: <20131213085950.GH4386@leaf>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2013 at 11:33:11AM +0530, Rashika Kheria wrote:
> This patch marks the function mpt_SoftResetHandler() as static in mpt=
base.c
> because it is not used outside this file.
>=20
> Thus, it also eliminates the following warning in fusion/mptbase.c:
> drivers/message/fusion/mptbase.c:7011:1: warning: no previous prototy=
pe for =E2=80=98mpt_SoftResetHandler=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/message/fusion/mptbase.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusio=
n/mptbase.c
> index 767ff4d..c783a42 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -7007,7 +7007,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
>   *	IOC doesn't reply to any outstanding request. This will transfer =
IOC
>   *	to READY state.
>   **/
> -int
> +static int
>  mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
>  {
>  	int		 rc;
> --=20
> 1.7.9.5
>=20
