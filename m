From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 18/25] External array LUNs must use target and lun
 numbers assigned by the
Date: Fri, 30 Oct 2015 09:11:50 +0100
Message-ID: <56332646.4000608@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220619.5323.76892.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965675AbbJ3ILw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:11:52 -0400
In-Reply-To: <20151028220619.5323.76892.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:06 PM, Don Brace wrote:
> From: Scott Teel <scott.teel@pmcs.com>
>=20
> external array. So the driver must treat these differently from
> local LUNs when assigning lun/target.
>=20
Please fixup the description; looks like it has been incorrectly
broken up during git commit.

> LUN's 'model' field has been used to detect Lun types that need
> special treatment, but the desire is to eliminate the need to referen=
ce
> specific array models, and support any external array.
>=20
> Pass-through RAID (PTRAID) luns are not luns of the local controller,
> so they are not reported in LUN count of command 'ID controller'.
> However, they ARE reported in "Report logical Luns" command.
> Local luns are listed first, then PTRAID LUNs.
>=20
> The number of luns from "Report LUNs" in excess of those reported by
> 'ID controller' are therefore the PTRAID LUNS.
>=20
> We can now remove function is_ext_target, and the 'white list'
> array of supported model names.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
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
