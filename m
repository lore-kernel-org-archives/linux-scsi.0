From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/11] scsi: add new scsi-command flag for tagged commands
Date: Tue, 04 Nov 2014 11:44:23 +0100
Message-ID: <5458AE07.7000004@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-3-git-send-email-hch@lst.de> <5458906D.4090708@suse.de> <20141104103535.GB19154@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaKDKo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:44:26 -0500
In-Reply-To: <20141104103535.GB19154@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 11:35 AM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 09:38:05AM +0100, Hannes Reinecke wrote:
>> Hmm. Flags with just one value in it ...
>> bitfield, maybe?
>=20
> Bitfields are nasty.  And I see more use for flags, e.g. whatever is
> left of eh_ehflags after the no_async_abort removal could be merged i=
nto
> it.
>=20
Ack. Fair enough.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
