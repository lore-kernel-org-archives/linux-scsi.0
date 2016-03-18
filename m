From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libata: Set longer timeout for SETFEATURES_SPINUP
Date: Fri, 18 Mar 2016 07:59:33 +0100
Message-ID: <56EBA755.3080603@suse.de>
References: <0810B2A7-DEA9-417D-8CCF-6A62BEFD9783@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbcCRG7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 02:59:37 -0400
In-Reply-To: <0810B2A7-DEA9-417D-8CCF-6A62BEFD9783@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/18/2016 05:49 AM, Damien Le Moal wrote:
>=20
> libata: Set longer timeout for SETFEATURES_SPINUP
>    =20
> For SATA drives with power-up in standby (PUIS) feature set,
> SETFEATURES_SPINUP execution may be required to get
> complete IDENTIFY data. However, the timeout used for its
> execution is the same as for all other SETFEATURES commands,
> that is, 5 seconds. This is too short for some disks to complete
> timeout and allow IDENTIFY to return complete data (e.g.
> disks with large indirection tables stored on media), resulting
> in ata_dev_read_id to fail. For this feature, allow a larger
> timeout of 30 seconds.
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

(BTW, you might want to add your Signed-off-by:, too :-)

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
