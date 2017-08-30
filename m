From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: reqs and tasks were put in the wrong order
Date: Wed, 30 Aug 2017 13:44:06 +0000
Message-ID: <DM5PR04MB108587D5F910C4FDE4190418FC9C0@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <20170824025715.98737-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60188 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3NpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 09:45:02 -0400
In-Reply-To: <20170824025715.98737-1-zangleigang@hisilicon.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Zang Leigang
> Sent: Thursday, August 24, 2017 5:57 AM
> To: vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] scsi: ufs: reqs and tasks were put in the wrong order
>=20
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
Acked-by: Avri Altman <avri.altman@sandisk.com>

>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 5bc9dc14e075..794a4600e952 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -438,7 +438,7 @@ static void ufshcd_print_host_state(struct ufs_hba
> *hba)  {
>  	dev_err(hba->dev, "UFS Host state=3D%d\n", hba->ufshcd_state);
>  	dev_err(hba->dev, "lrb in use=3D0x%lx, outstanding reqs=3D0x%lx
> tasks=3D0x%lx\n",
> -		hba->lrb_in_use, hba->outstanding_tasks, hba-
> >outstanding_reqs);
> +		hba->lrb_in_use, hba->outstanding_reqs, hba-
> >outstanding_tasks);
>  	dev_err(hba->dev, "saved_err=3D0x%x, saved_uic_err=3D0x%x\n",
>  		hba->saved_err, hba->saved_uic_err);
>  	dev_err(hba->dev, "Device power mode=3D%d, UIC link state=3D%d\n",
> --
> 2.14.1
