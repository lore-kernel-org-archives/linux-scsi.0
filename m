From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] scsi: stop passing a gfp_mask argument down the command
 setup path
Date: Thu, 06 Nov 2014 09:24:19 +0100
Message-ID: <545B3033.6070406@suse.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaKFIYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:24:20 -0500
In-Reply-To: <1415259630-20784-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

On 11/06/2014 08:40 AM, Christoph Hellwig wrote:
> There is no reason for ULDs to pass in a flag on how to allocate the =
S/G
> lists.  While we don't need GFP_ATOMIC for the blk-mq case because we
> don't hold locks, that decision can be made way down the chain withou=
t
> having to pass a pointless gfp_mask argument.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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
