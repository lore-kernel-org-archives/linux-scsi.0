From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 02/43] hpsa: clean up host, channel, target, lun prints
Date: Fri, 17 Apr 2015 14:53:49 +0200
Message-ID: <5531025D.3020505@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134650.30238.61648.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbDQMxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 08:53:50 -0400
In-Reply-To: <20150416134650.30238.61648.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:46 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>=20
> We had a mix of formats used for specifying controller, bus, target,
> and lun address of devices.
>=20
> change to the format used by the scsi midlayer and upper layer (2:3:0=
:0)
> so you can easily follow the information from hpsa to scsi midlayer
> to sd upper layer.
>=20
> Also add this information:
> - product ID
> - vendor ID
> - RAID level
> - SSD Smath Path capable and enabled
> - exposure level (sg-only)
>=20
> Example:
> hpsa 0000:04:00.0: added scsi 2:0:0:0: Direct-Access     HP LOGICAL V=
OLUME   RAID-0 SSDSmartPathCap+ En+ Exp=3D4
> scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 =
ANSI: 5
> sd 2:0:0:0: [sdr] 12501713072 512-byte logical blocks: (6.40 TB/5.82 =
TiB)
> sd 2:0:0:0: [sdr] 4096-byte physical blocks
> sd 2:0:0:0: [sdr] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg20 type 0
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

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
