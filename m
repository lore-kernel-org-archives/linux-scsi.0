From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Remove stale variables
Date: Thu, 03 Dec 2015 10:23:23 +0100
Message-ID: <1449134603.3311.12.camel@suse.de>
References: <1449125855-66372-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415AbbLCJXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 04:23:24 -0500
In-Reply-To: <1449125855-66372-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 07:57 +0100, Hannes Reinecke wrote:
> With commit 83ea0e5e3501 these variables became obsolete,
> but weren't removed.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 2 --
> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f100cbb..5a328bf 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,8 +320,6 @@ static int alua_check_tpgs(struct scsi_device *sd=
ev)
> =C2=A0 */
> =C2=A0static int alua_check_vpd(struct scsi_device *sdev, struct alua=
_dh_data *h)
> =C2=A0{
> -	unsigned char *d;
> -	unsigned char __rcu *vpd_pg83;
> =C2=A0	int rel_port =3D -1, group_id;
> =C2=A0
> =C2=A0	group_id =3D scsi_vpd_tpg_id(sdev, &rel_port);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
