From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/22] scsi: introduce sdev_prefix_printk()
Date: Mon, 01 Sep 2014 09:54:18 +0200
Message-ID: <5404262A.2060802@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-5-git-send-email-hare@suse.de> <20140831214303.GD18839@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaIAHyV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 03:54:21 -0400
In-Reply-To: <20140831214303.GD18839@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 08/31/2014 11:43 PM, Christoph Hellwig wrote:
> Needs a bit more description in the patch body and preferable also
> in a comment next to the macro.  What's the benefit of it over simply
> using sdev_printk with another argument?
>=20
This is particularly useful for ULDs which do not have access to the
scsi command directly.
I'll be updating the comments here.

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
