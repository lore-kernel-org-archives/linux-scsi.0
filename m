From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: correct logical resets
Date: Tue, 15 Nov 2016 15:59:20 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B0BAE3E@avsrvexchmbx1.microsemi.net>
References: <147881417483.804.10756927186886954941.stgit@brunhilda>
 <yq160npfwz9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0076.outbound.protection.outlook.com ([104.47.32.76]:63072
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752823AbcKOQOB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 11:14:01 -0500
In-Reply-To: <yq160npfwz9.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Bader Ali-saleh <bader.alisaleh@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, November 14, 2016 5:44 PM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; John Hall; Kevin Barnett; Mahesh
> Rajashekhara; Bader Ali-saleh; hch@infradead.org; Scott Teel; Viswas G;
> Justin Lindley; Scott Benesh; elliott@hpe.com; POSWALD@suse.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH] hpsa: correct logical resets
>=20
> EXTERNAL EMAIL
>=20
>=20
> >>>>> "Don" =3D=3D Don Brace <don.brace@microsemi.com> writes:
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0b6eb5a..a296537 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -300,6 +300,10 @@ static bool hpsa_cmd_dev_match(struct ctlr_info *h,
> struct CommandList *c,
>                                struct hpsa_scsi_dev_t *dev,
>                                unsigned char *scsi3addr);
>=20
> +static int wait_for_device_to_become_ready(struct ctlr_info *h,
> +                                          unsigned char lunaddr[],
> +                                          int reply_queue);
> +
>  static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
>  {
>         unsigned long *priv =3D shost_priv(sdev->host);
>=20
> Wouldn't it be nicer to put this with the rest of the function
> prototypes at the beginning of the file?
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering

Ok, I can move it up above
static int hpsa_wait_for_board_state(struct pci_dev *pdev, void __iomem *va=
ddr,
                                     int wait_for_ready);

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation


