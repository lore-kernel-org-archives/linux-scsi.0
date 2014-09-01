From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/22] scsi: dump sense buffer only for debugging
Date: Mon, 01 Sep 2014 10:26:51 +0200
Message-ID: <54042DCB.70209@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-9-git-send-email-hare@suse.de> <20140831220904.GD16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaIAI0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:26:53 -0400
In-Reply-To: <20140831220904.GD16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:09 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 07:33:22PM +0200, Hannes Reinecke wrote:
>> Dumping the entire sense buffer might overwhelm the logging function=
s,
>> so suppress it per default.
>=20
> Call me dumb, but I don't see anything in here that limits the dumps
> to debug output.
>=20
Yeah, you're right. This patch is pretty pointless.
I'll be removing it.

> Also if you return boolean-like values please use the bool type for i=
t.
> Also please switch scsi_normalize_sense over to return bool as well
> while you're at it.
>=20
Ok.

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
