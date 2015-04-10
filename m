From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/14] qla2xxx: Restore physical port WWPN only, when
 port down detected for FA-WWPN port.
Date: Fri, 10 Apr 2015 08:39:18 +0200
Message-ID: <55277016.3000007@suse.de>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com> <1428606008-14976-14-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbbDJGjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 02:39:20 -0400
In-Reply-To: <1428606008-14976-14-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 04/09/2015 09:00 PM, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@qlogic.com>
>=20
> For FA-WWPN is enabled port, if NPIV created on that port and,
> if port link is brought down, then WWPN was restored from flash for b=
oth
> physical and NPIV port. This will result in NPIV port and physical po=
rt
> sharing same WWPN. Any application refreshing ports information  will
> not be able to scan NPIV port because of this behavior. So while rest=
oring WWPN,
> only restore physical port WWPN.
>=20
> Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
