From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 21/25] hpsa: disable report lun data caching
Date: Fri, 30 Oct 2015 09:16:12 +0100
Message-ID: <5633274C.30103@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220638.5323.49466.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbJ3IQO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:16:14 -0400
In-Reply-To: <20151028220638.5323.49466.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:06 PM, Don Brace wrote:
> From: Scott Teel <scott.teel@pmcs.com>
>=20
> When external target arrays are present, disable the firmware's
> normal behavior of returning a cached copy of the report lun data,
> and force it to collect new data each time we request a report luns.
>=20
> This is necessary for external arrays, since there may be no
> reliable signal from the external array to the smart array when
> lun configuration changes, and thus when driver requests
> report luns, it may be stale data.
>=20
> Use diag options to turn off RPL data caching.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |   86 +++++++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/hpsa_cmd.h |    3 ++
>  2 files changed, 89 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
