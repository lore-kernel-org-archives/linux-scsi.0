From: Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH] driver core: device: add BUS_ATTR_WO macro
Date: Tue, 2 Oct 2018 09:43:35 +0000
Message-ID: <HE1PR0401MB236354F325B7A56355068E35E0E80@HE1PR0401MB2363.eurprd04.prod.outlook.com>
References: <1538407972-9340-1-git-send-email-ioana.ciornei@nxp.com>
 <20181001210804.GA24332@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001210804.GA24332@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, "sage@redhat.com" <sage@redhat.com>, "elder@kernel.org" <elder@kernel.org>, "jth@kernel.org" <jth@kernel.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > Add BUS_ATTR_WO macro to make it easier to add attributes without
> > auditing the mode settings. Also, use the newly added macro where
> > appropriate.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  arch/powerpc/platforms/pseries/ibmebus.c | 12 ++++----
> >  drivers/block/rbd.c                      | 48 ++++++++++++++++--------=
--------
> >  drivers/scsi/fcoe/fcoe_sysfs.c           |  4 +--
> >  drivers/scsi/fcoe/fcoe_transport.c       | 10 +++----
> >  include/linux/device.h                   |  2 ++
> >  include/scsi/libfcoe.h                   |  8 +++---
> >  6 files changed, 43 insertions(+), 41 deletions(-)
>=20
> Nice!  This duplicates a lot of the work I did back in July but have not =
pushed out
> very far due to the other things that ended up happening around that time=
:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/l=
og/?h=3Dbus_cleanup=20
>=20
> As the patch series seen at that link shows, you can do this in more plac=
es than
> just what you did here.
>=20
> Either way, you should break this up into the individual patches, like I =
did or you
> can take my patches if you want.  Getting the BUS_ATTR_WO() macro added i=
s
> good to do now, and then you can go and hit up all of the different subsy=
stems
> that should be converted over to it.

I can of course split my patch into individual ones and resubmit them, but =
as you already have the entire patch set ready, I feel like we can just pus=
h those. I looked through your changes and it seems like you covered all th=
e subsystems. Please let me know if there is something else I should do.

My intention here was to first add the _WO attribute so that afterwards I c=
an add a new bus attribute in the fsl-mc bus.

Ioana

>=20
> thanks,
>=20
> greg k-h
