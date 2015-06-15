From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/20] [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
Date: Mon, 15 Jun 2015 11:52:46 +0200
Message-ID: <20150615095246.GD5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-9-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbbFOJwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 05:52:49 -0400
Content-Disposition: inline
In-Reply-To: <1434102153-38581-9-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:20PM +0530, Sreekanth Reddy wrote:
> Update MPI2 strings to MPI2.5.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index 32b86bf..6739c0a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3901,7 +3901,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc=
, int sleep_flag)
>  	mpi_request.WhoInit =3D MPI2_WHOINIT_HOST_DRIVER;
>  	mpi_request.VF_ID =3D 0; /* TODO */
>  	mpi_request.VP_ID =3D 0;
> -	mpi_request.MsgVersion =3D cpu_to_le16(MPI2_VERSION);
> +	mpi_request.MsgVersion =3D cpu_to_le16(MPI25_VERSION);
>  	mpi_request.HeaderVersion =3D cpu_to_le16(MPI2_HEADER_VERSION);
> =20
>  	if (_base_is_controller_msix_enabled(ioc))
> @@ -4769,7 +4769,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc=
)
>  	ioc->build_sg_scmd =3D &_base_build_sg_scmd_ieee;
>  	ioc->build_sg =3D &_base_build_sg_ieee;
>  	ioc->build_zero_len_sge =3D &_base_build_zero_len_sge_ieee;
> -	ioc->mpi25 =3D 1;
>  	ioc->sge_size_ieee =3D sizeof(Mpi2IeeeSgeSimple64_t);
> =20
>  	/*
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3s=
as/mpt3sas_base.h
> index 9396a76..2318ef8 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -819,7 +819,6 @@ struct MPT3SAS_ADAPTER {
>  	MPT_BUILD_SG_SCMD build_sg_scmd;
>  	MPT_BUILD_SG    build_sg;
>  	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge;
> -	u8              mpi25;
>  	u16             sge_size_ieee;
> =20
>  	/* function ptr for MPI sg elements only */
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
