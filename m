From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] qed*: Utilize FW 8.33.11.0
Date: Tue, 27 Mar 2018 20:50:24 +0300
Message-ID: <20180327175024.GD1877@mtr-leonro.local>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
 <20180326211827.GG15554@ziepe.ca>
 <CY1PR0701MB201259F4DC154EFA6AE90E6F88AC0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FmwJltL8yKUx7YXQ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB201259F4DC154EFA6AE90E6F88AC0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tayar, Tomer" <Tomer.Tayar@cavium.com>, "Rangankar, Manish" <Manish.Rangankar@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org


--FmwJltL8yKUx7YXQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 27, 2018 at 05:41:51PM +0000, Kalderon, Michal wrote:
> > From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> > Sent: Tuesday, March 27, 2018 12:18 AM
> > > diff --git a/drivers/infiniband/hw/qedr/main.c
> > > b/drivers/infiniband/hw/qedr/main.c
> > > index db4bf97..7dbbe6d 100644
> > > +++ b/drivers/infiniband/hw/qedr/main.c
> > > @@ -51,6 +51,7 @@
> > >  MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
> > > MODULE_AUTHOR("QLogic Corporation");  MODULE_LICENSE("Dual
> > BSD/GPL");
> > > +MODULE_VERSION(QEDR_MODULE_VERSION);
> > >
> > >  #define QEDR_WQ_MULTIPLIER_DFT	(3)
> > >
> > > diff --git a/drivers/infiniband/hw/qedr/qedr.h
> > > b/drivers/infiniband/hw/qedr/qedr.h
> > > index 86d4511..ab0d411 100644
> > > +++ b/drivers/infiniband/hw/qedr/qedr.h
> > > @@ -43,6 +43,8 @@
> > >  #include "qedr_hsi_rdma.h"
> > >
> > >  #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
> > > +#define QEDR_MODULE_VERSION "8.33.11.20"
> > > +
> >
> > I thought we had a general prohibition against versions like this in mainline
> > drivers? And what does this hunk have to do with supporting new firmware?
> >
> > Jason
> I'm assuming you refer only to rdma in regards to version prohibition right ? as looking at all other vendors
> (including Mellanox) all have module versions under net/ why is rdma different in this way ?
> I now searched back mails on the topic and found an email from Leon where he stated:
> " I am strongly against module versions. You should rely on official kernel version."
> But it's not always the inbox driver that is installed or probed, the kernel version is not enough.
> Given different distros, vanilla kernels, out of box drivers, etc... it is essential for  us that based on
> logs And modinfo we can determine the qed* drivers that are running.

We actually stopped to maintain driver versions, just ensure that inbox,
upstream and MLNX_OFED have different names.

The discussion thread is here
https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-June/004426.html
https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-June/004441.html

>
> We have received complaints that our qedr module doesn't have a version whereas all of our other
> components do (qed, qede, qedi, qedf). We decided to add the qedr version with the next version
> update to align with the rest of the components.
>
> We can move the driver version bump into a different commit for all components, just made
> sense to Add it to this one as it is the root of the version update.
> Let me know if you think it is essential and I'll make the change for v2
>
> Thanks,
> Michal

--FmwJltL8yKUx7YXQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq6hGAACgkQ5GN7iDZy
WKdO3BAApE01dUDUlcg1PqVXyx8WuWUK8363h17TnphH6gnhCAajLdXoH5KPa1Gb
jPJ3r0KrIvtiO1IFU5aM4Ta14d1OdBxySwZNMqEroLZoDnPa8c8pQl3quZtkGFGM
KtMeL6++V99q11LkKY8Db3bdCRQau9N1tW52JTZaP+MqrbX4UwXkPlxJXVFsS23T
bDYwPzS07orTjMK+qtDRE67v+ZDOfhEeDr5gQf3lYf/wsVpZ2rQkBTBwdNInU4XC
EgAN31hHVj0mHO5+CofA9giMBInrxOyHe1FfdutZSMLEfD/Yxpdr78oQwH6bq+B6
uqef1YqbcmHo+I0FBv1YPz4BwNqAqPc4Hxom9mLR58no6Z0g578pAfSCRvDWDqEh
dR3iy/DNHwS+YQnST2Ck5RfvdtQxXsATR1BozTpIit5rpiOQNCeClPGX86qd7Ork
AkLU0pDK8IXQwq0G40cI+Czoy/qpQqT91/fGm+ZfJYemJBAY87WkikXq5jKuT9Jz
0Lix1r0JD9LkXzlHepvt8DY5MI5KhOVgX2CaTv/8H1rCa7x11cNUN56qigkSMKuL
C5zFc3T7V7tb+KQD5QKQs0QQzTnTVFe5d8LKIxqWxI1l/uTA77LNPbQZ9q8PZ8aH
h4uDWm0Wr4JBZWl3iWj+GDuoihwfZtDTFn3/TKxc1APHbF9GuLM=
=25LT
-----END PGP SIGNATURE-----

--FmwJltL8yKUx7YXQ--
