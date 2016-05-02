From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2.5 5/6] scsi_debug: uuid for lu name
Date: Mon, 2 May 2016 10:38:30 +0200
Message-ID: <57271206.4040406@suse.de>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-6-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbcEBIib (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 04:38:31 -0400
In-Reply-To: <1462070687-12689-6-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
> Permit changing of a LU name from a (fake) IEEE registered NAA (5)
> to a locally assigned UUID. Using a UUID (RFC 4122) for a SCSI
> designation descriptor (e.g. a LU name) was added in spc5r08.pdf
> (a draft INCITS standard) on 25 January 2016. Add parameter
> uuid_ctl to use a separate UUID for each LU (storage device) name.
> Additional option for all LU names to have the same UUID (since
> their storage is shared). Previous action of using NAA identifier
> for LU name remains the default.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 61 +++++++++++++++++++++++++++++++++++++=
++--------
>  1 file changed, 51 insertions(+), 10 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
