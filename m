From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/20] scsi_dh_alua: parse target device id
Date: Sat, 25 Jul 2015 18:00:19 +0200
Message-ID: <55B3B293.3040701@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>	<1436346378-96518-15-git-send-email-hare@suse.de>	<20150724150740.GB29434@lst.de> <yq1io99y3qi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbbGYQAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 12:00:21 -0400
In-Reply-To: <yq1io99y3qi.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 05:28 PM, Martin K. Petersen wrote:
>>>>>> "Christoph" =3D=3D Christoph Hellwig <hch@lst.de> writes:
>=20
> Christoph> Can you move this to scsi_mod.ko?  I'll need the same code
> Christoph> for the NFS SCSI layout driver soon.
>=20
> Same here. Working on copy offload again.
>=20
Hehe. Thought that was needed after all.
(I dimly remember having some parsing code in my initial VPD page
patchset :-)

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
