From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 6/8] bsg-lib: handle bidi requests without block layer
 help
Date: Mon, 19 Nov 2018 12:31:54 +0000
Message-ID: <SN6PR04MB49254C8E18E28233E904A006FCD80@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20181111133211.13926-1-hch@lst.de>
 <20181111133211.13926-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111133211.13926-7-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ooo@electrozaur.com" <ooo@electrozaur.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Christoph Hellwig
> Sent: Sunday, November 11, 2018 3:32 PM
> To: axboe@kernel.dk; martin.petersen@oracle.com; ooo@electrozaur.com
> Cc: Johannes Thumshirn <jthumshirn@suse.de>; Benjamin Block
> <bblock@linux.vnet.ibm.com>; linux-scsi@vger.kernel.org; linux-
> block@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 6/8] bsg-lib: handle bidi requests without block layer he=
lp
>=20
> We can just stash away the second request in struct bsg_job instead
> of using the block layer req->next_rq field, allowing for the eventual
> removal of the latter.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Avri Altman <avri.altman@wdc.com>

Regardless of the ongoing discussion with Benjamin -=20
Tested the scsi pass-through (ufs-bsg) path - nothing is broken.
