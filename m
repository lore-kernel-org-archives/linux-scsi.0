From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: remove task_collector mode
Date: Mon, 24 Nov 2014 10:01:20 +0100
Message-ID: <5472F3E0.1040409@suse.de>
References: <1416818502-19584-1-git-send-email-hch@lst.de> <5472F19D.3070600@suse.de> <20141124085440.GA19283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaKXJBW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 04:01:22 -0500
In-Reply-To: <20141124085440.GA19283@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Chen Gang <gang.chen.5i5j@gmail.com>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>

On 11/24/2014 09:54 AM, Christoph Hellwig wrote:
>> Why did you not remove the last argument from asd_can_queue() and
>> asd_can_dequeue(), too?
>> With that patch it's always '1' ...
>=20
> Because I wanted to remove the libsas (mis-)feature and avoid to many=
 boad
> driver changes.  Especially for a unmaintained big driver like aic94x=
x.
>=20
>> This 'while' loop can go, too.
>=20
> Same here.  Note that this driver never even allowed task collector m=
ode,
> so it was already dead code.
>=20
Okay.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
