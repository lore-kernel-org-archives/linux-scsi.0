From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 11/31] block: Introduce queue flag QUEUE_FLAG_SCSI_SUP
Date: Wed, 24 May 2017 15:05:28 +0000
Message-ID: <1495638326.2823.1.camel@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
         <20170524003420.5381-12-bart.vanassche@sandisk.com>
         <ff6777f8-eb90-224c-a615-3dca235d1d18@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62400 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968318AbdEXPFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 11:05:32 -0400
In-Reply-To: <ff6777f8-eb90-224c-a615-3dca235d1d18@suse.de>
Content-Language: en-US
Content-ID: <20F66673948DB74E8B23632E296A85FB@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>

On Wed, 2017-05-24 at 08:01 +0200, Hannes Reinecke wrote:
> On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> > From the context where a SCSI command is submitted it is not always
> > possible to figure out whether or not the queue the command is
> > submitted to has struct scsi_request as the first member of its
> > private data. Hence introduce the flag QUEUE_FLAG_SCSI_SUP.
> >=20
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Jens Axboe <axboe@fb.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Omar Sandoval <osandov@fb.com>
> > Cc: Hannes Reinecke <hare@suse.com>
> > ---
> >  block/bsg-lib.c                   | 1 +
> >  drivers/block/cciss.c             | 1 +
> >  drivers/ide/ide-probe.c           | 1 +
> >  drivers/scsi/scsi_lib.c           | 2 ++
> >  drivers/scsi/scsi_transport_sas.c | 1 +
> >  include/linux/blkdev.h            | 2 ++
> >  6 files changed, 8 insertions(+)
> >=20
>=20
> Bit of an odd name; what about QUEUE_FLAG_SCSI_PDU?

Hello Hannes,

That sounds like a good idea to me. I will rename the flag when I repost th=
is
series.

Bart.=
