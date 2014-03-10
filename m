From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/5] megaraid_sas: Updates for scsi-misc
Date: Mon, 10 Mar 2014 12:13:56 +0100
Message-ID: <531D9E74.9000802@suse.de>
References: <CAHtARFHcaLNbNFrGYRU9SQpJzhhESM0=TVZ5X2Rz_=1fLvk_rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaCJLN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 07:13:58 -0400
In-Reply-To: <CAHtARFHcaLNbNFrGYRU9SQpJzhhESM0=TVZ5X2Rz_=1fLvk_rg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

On 03/10/2014 10:51 AM, adam radford wrote:
> James/linux-scsi,
>=20
> The following patch series for megaraid_sas brings the driver up to
> v06.803.01.00-rc1:
>=20
> 1. Load correct raid context timeout value for multipathing and clust=
ering.
> 2. Fix megasas_ioc_init_fusion to use local stack variable.
> 3. Return leaked MPT frames to MPT command pool.
> 4. Add Dell PowerEdge VRTX SR-IOV VF device support.
> 5. Version and Changelog update.
>=20
> This patch series apples on top of Sumit Saxena's latest patch series=
, which
> starts here:
>=20
> http://marc.info/?l=3Dlinux-scsi&m=3D139220849616649&w=3D2
>=20
> and includes a small repost here:
>=20
> http://marc.info/?l=3Dlinux-scsi&m=3D139374736120535&w=3D2
>=20
Patch series is lacking coding style. Please re-check with
'./scripts/checkpatch.pl

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
