From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 26/43] hpsa: add support sending aborts to physical
 devices via the ioaccel2 path
Date: Fri, 17 Apr 2015 15:22:45 +0200
Message-ID: <55310925.9030503@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134904.30238.9380.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbbDQNWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:22:48 -0400
In-Reply-To: <20150416134904.30238.9380.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> add support for tmf when in ioaccel2 mode
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  136 +++++++++++++++++++++++++++++++++++++=
++++++++--
>  drivers/scsi/hpsa.h     |    1=20
>  drivers/scsi/hpsa_cmd.h |    6 +-
>  3 files changed, 135 insertions(+), 8 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
