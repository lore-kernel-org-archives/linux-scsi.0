From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 5/8] bsg: refactor bsg_ioctl
Date: Mon, 19 Nov 2018 12:29:27 +0000
Message-ID: <SN6PR04MB4925E6D8EC8D401B8C947F37FCD80@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20181111133211.13926-1-hch@lst.de>
 <20181111133211.13926-6-hch@lst.de> <20181113140550.GA7222@w530-pk1mzal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181113140550.GA7222@w530-pk1mzal>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ooo@electrozaur.com" <ooo@electrozaur.com>, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



=20
> On Sun, Nov 11, 2018 at 02:32:08PM +0100, Christoph Hellwig wrote:
> > Move all actual functionality into helpers, just leaving the dispatch
> > in this function.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/bsg.c | 158 ++++++++++++++++++++++++----------------------------
> >  1 file changed, 72 insertions(+), 86 deletions(-)
> >
>=20
> Looks fine to me. Did ran the same small test-tool I ran against Jens'
> patches, nothing broke.
>=20
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> Tested-by: Benjamin Block <bblock@linux.ibm.com>
Tested-by: Avri Altman <avri.altman@wdc.com>

Tested the scsi pass-through (ufs-bsg) path - nothing is broken.=20
