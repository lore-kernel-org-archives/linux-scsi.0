From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 09/11] qla2xxx: Enable T10-DIF for ISP27XX
Date: Thu, 28 Jan 2016 10:00:56 +0100
Message-ID: <20160128090056.GN27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-10-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934180AbcA1JA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 04:00:59 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-10-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:36PM -0500, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla=
_os.c
> index d94a236..fa017e9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2217,6 +2217,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  		ha->device_type |=3D DT_ZIO_SUPPORTED;
>  		ha->device_type |=3D DT_FWI2;
>  		ha->device_type |=3D DT_IIDMA;
> +		ha->device_type |=3D DT_T10_PI;
>  		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
>  		break;
>  	case PCI_DEVICE_ID_QLOGIC_ISP2271:
> @@ -2224,6 +2225,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  		ha->device_type |=3D DT_ZIO_SUPPORTED;
>  		ha->device_type |=3D DT_FWI2;
>  		ha->device_type |=3D DT_IIDMA;
> +		ha->device_type |=3D DT_T10_PI;
>  		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
>  		break;
>  	case PCI_DEVICE_ID_QLOGIC_ISP2261:
> @@ -2231,6 +2233,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  		ha->device_type |=3D DT_ZIO_SUPPORTED;
>  		ha->device_type |=3D DT_FWI2;
>  		ha->device_type |=3D DT_IIDMA;
> +		ha->device_type |=3D DT_T10_PI;
>  		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
>  		break;
>  	}
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
