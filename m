From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 14/25] hpsa: add function is_logical_device
Date: Fri, 30 Oct 2015 09:05:49 +0100
Message-ID: <563324DD.6000303@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220555.5323.38019.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545AbbJ3IFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:05:51 -0400
In-Reply-To: <20151028220555.5323.38019.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:05 PM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@pmcs.com>
>=20
> simplify checking for logical/physical devices
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
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
