From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] scsi: Add 'access_state' attribute
Date: Thu, 09 Jul 2015 10:43:48 +0200
Message-ID: <559E3444.2020301@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-4-git-send-email-hare@suse.de> <20150709082217.GA1419@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbbGIInu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 04:43:50 -0400
In-Reply-To: <20150709082217.GA1419@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/09/2015 10:22 AM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 01:09:46PM +0200, Hannes Reinecke wrote:
>> Add an 'access_state' attribute to display the LUN access state.
>=20
> Should we just reuse the ALUA values here as they part of the spec
> and map the legacy implemetation values to it?
>=20
That's what I've attempted to; only I've displayed them as text,
not as a numeric value.
But sure, the idea was to take the ALUA values and map legacy
implementation onto it.

> I'd also really love to store the access_state variable in
> struct scsi_device so we can perform the checks for it in core code
> instead of the device handlers.
>=20
That would be a good idea indeed. I had been pondering the idea of a
revamped multipath integration, where this would be come in handy.

I can easily adapt the patches here.

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
