From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: do not manipulate device reference counts in
 scsi_get/put_command
Date: Fri, 21 Feb 2014 13:20:04 +0100
Message-ID: <53074474.2050801@suse.de>
References: <20140220222052.717958451@bombadil.infradead.org> <20140220222357.115614698@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaBUMUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Feb 2014 07:20:05 -0500
In-Reply-To: <20140220222357.115614698@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

On 02/20/2014 11:20 PM, Christoph Hellwig wrote:
> Many callers won't need this and we can optimize them away.  In addit=
ion
> the handling in the __-prefixed variants was inconsistant to start wi=
th.
>=20
> Based on an earlier patch from Bart Van Assche.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Hannes Reinecke <hare@suse.de>

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
