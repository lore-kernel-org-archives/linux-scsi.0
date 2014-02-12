From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] scsi: avoid useless free_list lock roundtrips
Date: Wed, 12 Feb 2014 11:53:54 +0100
Message-ID: <52FB52C2.5070207@suse.de>
References: <20140206184306.997538898@bombadil.infradead.org> <20140206184417.414170526@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaBLKx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 05:53:56 -0500
In-Reply-To: <20140206184417.414170526@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 02/06/2014 07:43 PM, Christoph Hellwig wrote:
> Avoid hitting the host-wide free_list lock unless we need to put a co=
mmand
> back onto the freelist.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Looks good.

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
