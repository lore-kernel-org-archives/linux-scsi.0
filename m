From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 20/25] hpsa: add discovery polling for PT RAID devices.
Date: Fri, 30 Oct 2015 09:15:20 +0100
Message-ID: <56332718.1030703@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220631.5323.15176.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbJ3IPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:15:23 -0400
In-Reply-To: <20151028220631.5323.15176.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:06 PM, Don Brace wrote:
> From: Scott Teel <scott.teel@pmcs.com>
>=20
> There are problems with getting configuration change notification
> in pass-through RAID environments.  So, activate flag
> h->discovery_polling when one of these devices is detected in
> update_scsi_devices.
>=20
> After discovery_polling is set, execute a report luns from
> rescan_controller_worker (every 30 seconds).
>=20
> If the data from report_luns is different than last
> time (binary compare), execute a full rescan via update_scsi_devices.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   68 +++++++++++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/hpsa.h |    2 ++
>  2 files changed, 70 insertions(+)
>=20
Hmm. Can't say I like it, but if there's no other way...

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
