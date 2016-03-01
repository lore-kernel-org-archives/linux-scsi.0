From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] scsi: Add 'access_state' and 'preferred_path'
 attribute
Date: Tue, 1 Mar 2016 16:01:25 +0800
Message-ID: <56D54C55.8040101@suse.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
 <1456808143-88932-2-git-send-email-hare@suse.de>
 <DDB9C85B850785449757F9914A034FCB4453A465@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbcCAIBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 03:01:42 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4453A465@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/01/2016 03:08 PM, Seymour, Shane M wrote:
> in https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt
>=20
> it says:
>=20
> - show() must not use snprintf() when formatting the value to be
>   returned to user space. If you can guarantee that an overflow
>   will never happen you can use sprintf() otherwise you must use
>   scnprintf().
>=20
So? I _do_ know the length of the strings I'm going to write into the
buffer, so there cannot possibly be an overflow.
Unless I've made an error during calculation of the string length, of
course. But both functions can only return fixed length strings, so I'm
safe here.

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
