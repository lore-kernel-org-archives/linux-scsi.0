From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: return value warnings about scsi_add_host, anything in progre
	ss?
Date: Mon, 7 Feb 2005 08:47:36 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from mail0.lsil.com ([147.145.40.20]:17326 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261301AbVBGNrm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 08:47:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Alexander Stohr' <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org
Cc: "Ju, Seokmann" <sju@lsil.com>

On Monday, February 07, 2005 4:40 AM, Alex wrote:
> is anything going to happen with the below listed locations?
> (Some are part of the USB system, one is in block device, rest is SCS=
I.)
> Note that a few locations do still lack the "XXX" comment.
>=20
> I am asking because i am seeing ther respective warning
> anytime when i am checking the quality of a new linux kernel.
> And now i am wondering if there is already some work in progress
> or already pending in the queue for submitting to bitkeeper.

Hi Alex,

Can you please elaborate the issue and what you'd expect from it?

Thanks,

Seokmann
LSI Logic Corporation.

> -----Original Message-----
> From: Alexander Stohr [mailto:Alexander.Stohr@gmx.de]
> Sent: Monday, February 07, 2005 4:40 AM
> To: linux-scsi@vger.kernel.org
> Subject: return value warnings about scsi_add_host, anything in progr=
ess?
>=20
> Hello,
>=20
> is anything going to happen with the below listed locations?
> (Some are part of the USB system, one is in block device, rest is SCS=
I.)
> Note that a few locations do still lack the "XXX" comment.
>=20
> I am asking because i am seeing ther respective warning
> anytime when i am checking the quality of a new linux kernel.
> And now i am wondering if there is already some work in progress
> or already pending in the queue for submitting to bitkeeper.
>=20
> -Alex.
>=20
> PS: i am not subscribed to that list, so please CC me on replys.
> Hunting answers via the list archives is not always successful.
>=20
>=20
> ./drivers/usb/image/hpusbscsi.c:112:    scsi_add_host(new->host,
> &intf->dev); /* XXX handle failure */
>=20
> ./drivers/usb/image/microtek.c:812:     scsi_add_host(new_desc->host,
> NULL);
> /* XXX handle failure */
>=20
> ./drivers/scsi/arm/ecoscsi.c:208:       scsi_add_host(host, NULL); /*=
 XXX
> handle failure */
>=20
> ./drivers/scsi/megaraid.c:4890: error =3D scsi_add_host(host, &pdev->=
dev);
>=20
> ./drivers/scsi/aic7xxx/aic7xxx_osm.c:1732:      scsi_add_host(host,
> (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failur=
e */
>=20
> ./drivers/scsi/aic7xxx/aic79xx_osm.c:2068:      scsi_add_host(host,
> &ahd->dev_softc->dev); /* XXX handle failure */
>=20
> ./drivers/scsi/pcmcia/fdomain_stub.c:226:    scsi_add_host(host, NULL=
); /*
> XXX handle failure */
>=20
> ./drivers/scsi/pcmcia/nsp_cs.c:1908:    scsi_add_host (host, NULL);
>=20
> ./drivers/scsi/mac53c94.c:506:  scsi_add_host(host, &mdev->ofdev.dev)=
;
>=20
> ./drivers/scsi/nsp32.c:2891:    scsi_add_host (host, &PCIDEV->dev);
>=20
> ./drivers/scsi/mesh.c:1963:     scsi_add_host(mesh_host, &mdev-
> >ofdev.dev);
>=20
> ./drivers/scsi/aha1740.c:645:   scsi_add_host (shpnt, dev); /* XXX ha=
ndle
> failure */
>=20
> ./drivers/scsi/BusLogic.c:2299:
scsi_add_host(Host,
> NULL);
>=20
> ./drivers/block/cciss_scsi.c:709:       scsi_add_host(sh,
> &hba[ctlr]->pdev->dev); /* XXX handle failure *
>=20
> --
> DSL Komplett von GMX +++ Superg=FCnstig und stressfrei einsteigen!
> AKTION "Kein Einrichtungspreis" nutzen: http://www.gmx.net/de/go/dsl
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
