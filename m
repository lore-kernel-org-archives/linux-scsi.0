From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/26] scsi: simplify scsi_log_(send|completion)
Date: Tue, 07 Oct 2014 10:45:45 +0200
Message-ID: <5433A839.2060004@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>	 <1412586086-129821-22-git-send-email-hare@suse.de> <1412625183.5241.148.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJGIps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 04:45:48 -0400
In-Reply-To: <1412625183.5241.148.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On 10/06/2014 09:53 PM, Ewan Milne wrote:
> Rats.  I found another case of "(null)" appearing in the log messages
> where I think you really just wanted no text at all to appear.
> Sorry I didn't find it last time along with the other one...
>=20
Nae bother. I'll be sending a new version of the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
