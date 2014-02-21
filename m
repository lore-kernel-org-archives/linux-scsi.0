From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] scsi: avoid taking host_lock in scsi_run_queue unless
 nessecary
Date: Fri, 21 Feb 2014 13:19:17 +0100
Message-ID: <53074445.8030000@suse.de>
References: <20140220222052.717958451@bombadil.infradead.org> <20140220222356.899671950@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaBUMTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Feb 2014 07:19:18 -0500
In-Reply-To: <20140220222356.899671950@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

On 02/20/2014 11:20 PM, Christoph Hellwig wrote:
> If we don't have starved devices we don't need to take the host lock
> to iterate over them.  Also split the function up to be more clear.
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
