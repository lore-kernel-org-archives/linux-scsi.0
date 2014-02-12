From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] scsi: do not manipulate device reference counts in
 scsi_get/put_command
Date: Wed, 12 Feb 2014 12:37:26 +0100
Message-ID: <52FB5CF6.5010501@suse.de>
References: <20140206184306.997538898@bombadil.infradead.org> <20140206184417.692440766@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaBLLh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 06:37:27 -0500
In-Reply-To: <20140206184417.692440766@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 02/06/2014 07:43 PM, Christoph Hellwig wrote:
> Many callers won't need this and we can optimize them away.  In addit=
ion
> the handling in the __-prefixed variants was inconsistant to start wi=
th.
>=20
> Based on an earlier patch from Bart Van Assche.
>=20
But this decouples the scsi_device refcount from the number of
outstanding commands, right?
While I'm sure you've audited all call sites, it's now up to the
callers to provide proper reference counting.
Shouldn't we document it somewhere?

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
