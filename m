From: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Subject: RE: [PATCH net-next] qed*: Utilize FW 8.33.11.0
Date: Wed, 28 Mar 2018 08:27:28 +0000
Message-ID: <CY1PR0701MB20127DF5A436C643C2E35F9588A30@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
 <20180326211827.GG15554@ziepe.ca>
 <CY1PR0701MB201259F4DC154EFA6AE90E6F88AC0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180327175024.GD1877@mtr-leonro.local> <20180327222716.GA3918@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327222716.GA3918@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tayar, Tomer" <Tomer.Tayar@cavium.com>, "Rangankar, Manish" <Manish.Rangankar@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> Sent: Wednesday, March 28, 2018 1:27 AM
>=20
> On Tue, Mar 27, 2018 at 08:50:24PM +0300, Leon Romanovsky wrote:
> > On Tue, Mar 27, 2018 at 05:41:51PM +0000, Kalderon, Michal wrote:
> > > > From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> > > > Sent: Tuesday, March 27, 2018 12:18 AM
> > > > > diff --git a/drivers/infiniband/hw/qedr/main.c
> > > > > b/drivers/infiniband/hw/qedr/main.c
> > > > > index db4bf97..7dbbe6d 100644
> > > > > +++ b/drivers/infiniband/hw/qedr/main.c
> > > > > @@ -51,6 +51,7 @@
> > > > >  MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
> > > > > MODULE_AUTHOR("QLogic Corporation");  MODULE_LICENSE("Dual
> > > > BSD/GPL");
> > > > > +MODULE_VERSION(QEDR_MODULE_VERSION);
> > > > >
> > > > >  #define QEDR_WQ_MULTIPLIER_DFT	(3)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/qedr/qedr.h
> > > > > b/drivers/infiniband/hw/qedr/qedr.h
> > > > > index 86d4511..ab0d411 100644
> > > > > +++ b/drivers/infiniband/hw/qedr/qedr.h
> > > > > @@ -43,6 +43,8 @@
> > > > >  #include "qedr_hsi_rdma.h"
> > > > >
> > > > >  #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
> > > > > +#define QEDR_MODULE_VERSION "8.33.11.20"
> > > > > +
> > > >
> > > > I thought we had a general prohibition against versions like this
> > > > in mainline drivers? And what does this hunk have to do with
> > > > supporting new firmware?
> > > >
> > > I'm assuming you refer only to rdma in regards to version
> > > prohibition right ? as looking at all other vendors (including
> > > Mellanox) all have module versions under net/ why is rdma different
> > > in this way ?  I now searched back mails on the topic and found an
> > > email from Leon where he stated: " I am strongly against module
> > > versions. You should rely on official kernel version."  But it's not
> > > always the inbox driver that is installed or probed, the kernel
> > > version is not enough.  Given different distros, vanilla kernels,
> > > out of box drivers, etc... it is essential for us that based on logs
> > > And modinfo we can determine the qed* drivers that are running.
> >
> > We actually stopped to maintain driver versions, just ensure that
> > inbox, upstream and MLNX_OFED have different names.
> >
> > The discussion thread is here
> > https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-June/
> > 004426.html
> > https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-June/
> > 004441.html
>=20
> Hmm, Linus pretty clearly said No to MODULE_VERSION and related.
>=20
> So I can't take this hunk, and you shouldn't do in ethernet either, I gue=
ss.
>=20
> Honestly the idea that this version will somehow have meaning in the dist=
ro
> kernels is pretty far fetched. You think distros will backport patches ch=
anging
> version # in any way that will make some kind of sense?

Leon and Jason,  thanks for the references and explanations.=20
I'll send a V2 without a version bump.
Michal
>=20
> Jason
