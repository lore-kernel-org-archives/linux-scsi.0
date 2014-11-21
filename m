From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 00/37] Fixes, cleanups and modernization for NCR5380
 drivers
Date: Fri, 21 Nov 2014 09:59:15 +0100
Message-ID: <546EFEE3.4090207@suse.de>
References: <20141112051146.525489687@telegraphics.com.au> <20141120155659.GA2450@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271AbaKUI7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 03:59:18 -0500
In-Reply-To: <20141120155659.GA2450@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 11/20/2014 04:56 PM, Christoph Hellwig wrote:
> Thanks, I've applied all patches to the drivers-for-3.19 branch.
>=20
> I had a few rejects due to Hannes logging changes.  I think I've fixe=
d
> them properly, but please verify it.

Speaking of which, what is the decision for my next round of logging
updates?
I _think_ I've got all things fixed (minus the suggestion from Doug,
but this can be fixed up with the next round).

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
