From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 0/9] New EH command timeout handler
Date: Mon, 02 Sep 2013 10:54:13 +0200
Message-ID: <52245235.9020408@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <20130902082728.GA15554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab3IBIyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:16 -0400
In-Reply-To: <20130902082728.GA15554@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On 09/02/2013 10:27 AM, Christoph Hellwig wrote:
> One thing I'm still wondering is why we can't enable this globally,
> and if there is a reason it should be documented.
>=20
> As far as I can tell the actual calling context of the eh_abort_handl=
er
> doesn't change, so an LLDD would have to rely on some very specific
> side effects of being in EH to break, and we never guaranteed such
> specifics.
>=20
I don't mind. Having talked to the various SCSI folks everyone
agreed that calling abort asynchronously shouldn't do any harm.
At least as far as the SCSI spec goes.

As for documentation: I didn't document it it currently as with my
implementation it's pretty much an optional thing.
But if we were to enable it globally it surely should be documented.

So if there is a consensus I surely can enable it globally and
update the documentation.

James?

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
