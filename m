From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: use host wide tags by default
Date: Mon, 12 Oct 2015 14:28:48 +0200
Message-ID: <561BA780.5090006@suse.de>
References: <1444292884-8622-1-git-send-email-hch@lst.de> <1444292884-8622-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbbJLM2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 08:28:50 -0400
In-Reply-To: <1444292884-8622-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk

On 10/08/2015 10:28 AM, Christoph Hellwig wrote:
> This patch changes the !blk-mq path to the same defaults as the blk-m=
q
> I/O path by always enabling block tagging, and always using host wide
> tags.  We've had blk-mq available for a few releases so bugs with
> this mode should have been ironed out, and this ensures we get better
> coverage of over tagging setup over different configs.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
