From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Declare local functions static
Date: Fri, 15 Apr 2016 07:58:38 +0200
Message-ID: <5710830E.8060402@suse.de>
References: <570FD2F2.90506@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbcDOF6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 01:58:40 -0400
In-Reply-To: <570FD2F2.90506@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/14/2016 07:27 PM, Bart Van Assche wrote:
> This patch avoids that building with W=3D1 causes gcc to report the
> following type of warning:
>=20
>     no previous prototype for ... [-Wmissing-prototypes]
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ewan Milne <emilne@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 8eaed05..e034f12 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -190,8 +190,8 @@ static int submit_stpg(struct scsi_device *sdev, =
int group_id,
>  				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
>  }
> =20
> -struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_siz=
e,
> -					 int group_id)
> +static struct alua_port_group *alua_find_get_pg(char *id_str, size_t=
 id_size,
> +						int group_id)
>  {
>  	struct alua_port_group *pg;
> =20
> @@ -219,8 +219,8 @@ struct alua_port_group *alua_find_get_pg(char *id=
_str, size_t id_size,
>   * Allocate a new port_group structure for a given
>   * device.
>   */
> -struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
> -				      int group_id, int tpgs)
> +static struct alua_port_group *alua_alloc_pg(struct scsi_device *sde=
v,
> +					     int group_id, int tpgs)
>  {
>  	struct alua_port_group *pg, *tmp_pg;
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
