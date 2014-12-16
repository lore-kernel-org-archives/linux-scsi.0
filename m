From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Integrated Unit Attention handling
Date: Tue, 16 Dec 2014 16:30:34 +0100
Message-ID: <5490501A.2020706@suse.de>
References: <548EFB97.2080501@suse.de> <20141216083245.GA29219@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaLPPai (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2014 10:30:38 -0500
In-Reply-To: <20141216083245.GA29219@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 12/16/2014 09:32 AM, Christoph Hellwig wrote:
> Sounds like a good topic, altough I hope we'll see considerable
> progress before LSF on this item..
>=20
=46ull integration requires a change of the SCSI device model;
currently struct scsi_device has a fixed type and inquiry data, so
rescan is essentially a no-op.
So the current model requires the complete removal of the device and
a rescan on the host.
Doing that from within the SCSI stack will open quite some
interesting race conditions, let alone interesting userspace
interactions.
Alternatively we can change the model to allow for a change of the
inquiry data, but that should be discussed.

And then there is the Power-On/Reset handling, which probably would
warrant a discussion on its own ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
