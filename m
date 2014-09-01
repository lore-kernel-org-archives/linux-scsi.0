From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/22] Use sdev as argument for scsi_print_result
Date: Mon, 01 Sep 2014 10:43:17 +0200
Message-ID: <540431A5.4000609@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-10-git-send-email-hare@suse.de> <20140831221117.GE16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaIAInV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:43:21 -0400
In-Reply-To: <20140831221117.GE16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:11 AM, Christoph Hellwig wrote:
> Please also remove the now useless sd_print_result wrapper.
>=20
Done.

> Otherwise looks good,
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
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
