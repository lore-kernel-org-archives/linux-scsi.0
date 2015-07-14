From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Tue, 14 Jul 2015 13:22:37 +0200
Message-ID: <55A4F0FD.6070305@suse.de>
References: <20150713142439.GA14427@kernel.dk> <20150714071358.GA31117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbbGNLWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 07:22:38 -0400
In-Reply-To: <20150714071358.GA31117@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org

On 07/14/2015 09:13 AM, Christoph Hellwig wrote:
> Looks good:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
> I wonder if we should start to gradually phase out these tuables in t=
he
> host template.  It's not really more complicated to set them directly
> in the host anyway.

=46ully agreed. I would vote for making the host template read-only
and modify all drivers to use the shost setting.

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
