From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: any experience with PCI Express parallel scsi controllers?
Date: Tue, 20 Feb 2007 17:10:14 +0100
Message-ID: <45DB1D66.8010404@ext.bull.net>
References: <Pine.LNX.4.63.0702200959540.12650@gx620.engin.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35758 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965319AbXBTQKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 11:10:14 -0500
In-Reply-To: <Pine.LNX.4.63.0702200959540.12650@gx620.engin.umich.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christopher Allen Wing <wingc@engin.umich.edu>
Cc: linux-scsi@vger.kernel.org

may be SCSI to USB adapter ?

such adapters seen on commercial web sites...
(adaptec, belkin, ...)
but:
- USB2 mandatory
- driver for linux ?

regards
--
=46rederic Temporelli


Christopher Allen Wing a =E9crit :
> Hello,
>=20
> I'm trying to connect some older SCSI devices to new servers which on=
ly
> have PCI Express expansion slots.  Unfortunately it seems that there =
are
> very few parallel SCSI HBA cards available for PCI Express systems.=20
> Most SCSI controller manufacturers are only selling PCI-X cards if yo=
u
> want parallel SCSI.
>=20
>=20
> Has anyone else been in this situation?  One product that we found is=
 a
> board sold by HP (HP SC11Xe) based on a LSI Logic chipset.  This is a
> PCI Express controller with a single U320 parallel SCSI channel.  It =
is
> reasonably priced ($200); unfortunately, the documentation on HP's we=
b
> site states that it will only work with tape devices.  Is anyone
> familiar with this card who might know if this claim (that the card o=
nly
> works with tape drives) is true or false?
>=20
> Otherwise, Adaptec does not seem to sell any parallel SCSI cards for =
PCI
> Express; there are a few expensive PCI Express RAID controllers out
> there with parallel SCSI but I don't need a hardware RAID controller.=
=20
> There is also an ATTO Technology PCI Express card with parallel SCSI;=
 it
> sells for around $500.
>=20
>=20
> Any ideas or suggestions?
>=20
>=20
> Thanks a lot,
>=20
> Chris Wing
> wingc@engin.umich.edu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
