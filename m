From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 0/3][Resend] Display EVPD pages in sysfs
Date: Fri, 28 Feb 2014 08:27:12 +0100
Message-ID: <53103A50.5090603@suse.de>
References: <1392287281-75002-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaB1H1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 02:27:13 -0500
In-Reply-To: <1392287281-75002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On 02/13/2014 11:27 AM, Hannes Reinecke wrote:
> Hi all,
>=20
> After discussion with jejb I've dropped the EVPD parsing.
> So with this version we're just displaying the EVPD page
> 0x80 and 0x83 as hexdumps; no parsing is attempted.
> This drastically simplifies the patch, and we don't
> have to worry about any parsing errors in kernel space.
> Of course we'll need a parser in userspace, but that
> doesn't need to do any I/O. So it's still a very nice
> gain.
>=20
> (I had to redo the patchset as it no longer applied to
>  -rc2. Hence the resend. Sorry for that.)
>=20
> Hannes Reinecke (3):
>   scsi_sysfs: Implement 'is_visible' callback
>   Add EVPD page 0x83 to sysfs
>   Add EVPD page 0x80 to sysfs
>=20
>  drivers/scsi/scsi.c        | 104 ++++++++++++++++++--
>  drivers/scsi/scsi_scan.c   |   3 +
>  drivers/scsi/scsi_sysfs.c  | 229 +++++++++++++++++++++++++++--------=
----------
>  include/scsi/scsi_device.h |   5 +
>  4 files changed, 242 insertions(+), 99 deletions(-)
>=20
James, ping?

Anything amiss with that patchset?

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
