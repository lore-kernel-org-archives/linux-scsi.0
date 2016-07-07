From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] libata-scsi: do not return t10 designator if drive
 has WWN
Date: Thu, 7 Jul 2016 14:44:17 +0200
Message-ID: <577E4EA1.8050603@suse.de>
References: <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
 <577E356E.9050209@suse.de>
 <CAGnHSEnxFdSKzzhqMKUkFeaOH02M2E8sTo9H28eFRbv48QyUng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbcGGMpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 08:45:40 -0400
In-Reply-To: <CAGnHSEnxFdSKzzhqMKUkFeaOH02M2E8sTo9H28eFRbv48QyUng@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/07/2016 02:40 PM, Tom Yan wrote:
> Well, udev uses its own `ata_id` (which issues IDENTIFY DEVICE throug=
h
> ATA PASS-THROUGH) though.
>=20
> Anyway I expected the reasoning you gave and I can't really argue wit=
h
> you. It's just personally I still prefer a cleaner SATL implementatio=
n
> (considering Linux is open source and can be deemed as some sort of
> reference), so I gave it a go.
>=20
> Not that SAT requires the DI VPD return only one desingator / LU name=
 though.
>=20
Really?

sat-r08 has:

One identification descriptor for a logical unit (i.e., a logical unit
name) shall be included (see clause 10.3.4.2).
In some environments, one or more additional identification descriptors
may be included (see clause 10.3.4.3).

Am I misreading something?

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
