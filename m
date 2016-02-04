From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_rdac: always retry MODE SELECT on command lock
 violation
Date: Thu, 4 Feb 2016 08:01:44 +0100
Message-ID: <56B2F758.9050502@suse.de>
References: <1453473761-54777-1-git-send-email-hare@suse.de>
 <yq1y4b1i41e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbcBDHBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 02:01:46 -0500
In-Reply-To: <yq1y4b1i41e.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/04/2016 03:48 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> If MODE SELECT returns with sense '05/91/36' (command lock
> Hannes> violation) it should always be retried without counting the
> Hannes> number of retries.  During an HBA upgrade or similar
> Hannes> circumstances one might see a flood of MODE SELECT command fr=
om
> Hannes> various HBAs, which will easily trigger the sense code and
> Hannes> exceed the retry count.
>=20
> Should this be Cc: stable?
>=20
Probably, yes.

Can you do it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
