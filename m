From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] sd: fix up ->compat_ioctl
Date: Wed, 05 Nov 2014 15:13:16 +0100
Message-ID: <545A307C.70203@suse.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaKEONR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 09:13:17 -0500
In-Reply-To: <1414661229-15199-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/30/2014 10:27 AM, Christoph Hellwig wrote:
> No need to verify the passthrough ioctls, the real handler will
> take care of that.  Also make sure not to block for resets on
> O_NONBLOCK fds.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
