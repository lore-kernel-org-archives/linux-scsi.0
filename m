From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 08/23] scsi: introduce a result field in struct
 scsi_request
Date: Thu, 20 Apr 2017 15:25:12 +0000
Message-ID: <1492701911.2642.1.camel@sandisk.com>
References: <20170420140316.6546-1-hch@lst.de>
         <20170420140316.6546-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170420140316.6546-9-hch@lst.de>
Content-Language: en-US
Content-ID: <565F811036077348B5B65F98BBE1E636@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-04-20 at 16:03 +0200, Christoph Hellwig wrote:
> This passes on the scsi_cmnd result field to users of passthrough
> requests.  Currently we abuse req->errors for this purpose, but that
> field will go away in its current form.
>=20
> Note that the old IDE code abuses the errors field in very creative
> ways and stores all kinds of different values in it.  I didn't dare
> to touch this magic, so the abuses are brought forward 1:1.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
