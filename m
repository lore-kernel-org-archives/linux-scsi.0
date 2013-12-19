From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] drivers: target: Mark functions and structures as
 static in tfc_conf.c
Date: Wed, 18 Dec 2013 16:12:19 -0800
Message-ID: <1387411939.5567.11.camel@haakon3.risingtidesystems.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
	 <94a49e2b29220b2a3fb93449a7b2c96fb6ea4667.1387390091.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <94a49e2b29220b2a3fb93449a7b2c96fb6ea4667.1387390091.git.rashika.kheria@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-12-19 at 00:05 +0530, Rashika Kheria wrote:
> Mark functions ft_tpg_alloc_fabric_acl(), ft_register_configfs() and
> ft_deregister_configfs() as static in tcm_fc/tfc_conf.c because they =
are
> not used outside this file.
>=20
> This eliminates the following warnings in tcm_fc/tfc_conf.c:
> drivers/target/tcm_fc/tfc_conf.c:270:21: warning: no previous prototy=
pe for =E2=80=98ft_tpg_alloc_fabric_acl=E2=80=99 [-Wmissing-prototypes]
> drivers/target/tcm_fc/tfc_conf.c:555:5: warning: no previous prototyp=
e for =E2=80=98ft_register_configfs=E2=80=99 [-Wmissing-prototypes]
> drivers/target/tcm_fc/tfc_conf.c:602:6: warning: no previous prototyp=
e for =E2=80=98ft_deregister_configfs=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/target/tcm_fc/tfc_conf.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20

Applied to target-pending/for-next.

Thanks Rashika + Josh!

--nab

> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc=
/tfc_conf.c
> index c6932fb..e879da8 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -267,7 +267,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg=
, struct fc_rport_priv *rdata)
>  	return found;
>  }
> =20
> -struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *=
se_tpg)
> +static struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_=
group *se_tpg)
>  {
>  	struct ft_node_acl *acl;
> =20
> @@ -552,7 +552,7 @@ static struct target_core_fabric_ops ft_fabric_op=
s =3D {
>  	.fabric_drop_nodeacl =3D		&ft_del_acl,
>  };
> =20
> -int ft_register_configfs(void)
> +static int ft_register_configfs(void)
>  {
>  	struct target_fabric_configfs *fabric;
>  	int ret;
> @@ -599,7 +599,7 @@ int ft_register_configfs(void)
>  	return 0;
>  }
> =20
> -void ft_deregister_configfs(void)
> +static void ft_deregister_configfs(void)
>  {
>  	if (!ft_configfs)
>  		return;
