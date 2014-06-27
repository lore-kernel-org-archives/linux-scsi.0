From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [Xen-devel] Add XEN pvSCSI support
Date: Fri, 27 Jun 2014 20:51:18 +0300
Message-ID: <20140627175118.GX18930@reaktio.net>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <20140627174525.GW18930@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:38196 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaF0RvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 13:51:23 -0400
Content-Disposition: inline
In-Reply-To: <20140627174525.GW18930@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: James Harper <james.harper@bendigoit.com.au>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org

On Fri, Jun 27, 2014 at 08:45:25PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Fri, Jun 27, 2014 at 04:34:32PM +0200, jgross@suse.com wrote:
> > This series adds XEN pvSCSI support. With pvSCSI it is possible to =
use physical
> > SCSI devices from a XEN domain.
> >=20
> > The support consists of a backend in the privileged Domain-0 doing =
the real
> > I/O and a frontend in the unprivileged domU passing I/O-requests to=
 the backend.
> >=20
> > The code is taken (and adapted) from the original pvSCSI implementa=
tion done
> > for Linux 2.6 in 2008 by Fujitsu.
> >=20
>=20
> Great!=20
>=20
> I added James Harper to CC, I know he has a port of at least scsiback=
 aswell,
> and he has a PVSCSI frontend driver included in the GPLPV Windows Xen=
 PV drivers.
>=20
> Btw do these patches also include the "latest" PVSCSI fixes/enhanceme=
nts done in the SuSe/SLES kernel?
> (for example the RESERVE/RELEASE support).
>=20

Never mind, I noticed that RESERVE/RELEASE are included in the xen-scsi=
back driver patch.

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
