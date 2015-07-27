From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/52] atp870u: Major rework
Date: Mon, 27 Jul 2015 10:56:23 +0200
Message-ID: <55B5F237.8010207@suse.de>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbbG0I4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 04:56:25 -0400
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org

On 07/26/2015 10:24 PM, Ondrej Zary wrote:
> This patch series removes the first level of crap from atp870u - the =
worst
> (in-tree) SCSI driver [1] and then cleans up the code a bit.
>=20
> First the driver is converted to C from something that looks like a (=
bad)
> assembler code: use of tmport for all I/O accesses and gotos all over=
 the
> code.
> Then I/O access wrappers are introduced.
> Finally, is870, is880 and is885 are unified and two of them removed.
>=20
> After that, some cleanups are done. There's still a lot of work left =
to do.
>=20
> Tested on AEC-6710D (ATP870IU-C).
>=20
> [1] http://www.spinics.net/lists/linux-scsi/msg81142.html
>=20
>  atp870u.c | 3707 +++++++++++++++++----------------------------------=
-----------
>  atp870u.h |    4
>  2 files changed, 1064 insertions(+), 2647 deletions(-)
>=20
> Partially (up to patch 34) Acked-by: Christoph Hellwig <hch@lst.de>
>=20
=46or this patchset:

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
