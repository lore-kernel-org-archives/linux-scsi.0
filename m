From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi: return correct blkprep status code in case
 scsi_init_io() fails.
Date: Thu, 13 Apr 2017 15:16:19 +0000
Message-ID: <1492096576.3298.2.camel@sandisk.com>
References: <20170412072119.7529-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170412072119.7529-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <AC51257182611E4EB9EB8A4AB344B384@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-12 at 09:21 +0200, Johannes Thumshirn wrote:
> When instrumenting the SCSI layer to run into the
> !blk_rq_nr_phys_segments(rq) case the following  warning emitted from the
> block layer:
>=20
> blk_peek_request: bad return=3D-22
>=20
> This happens because since commit fd3fc0b4d730 ('scsi: don't BUG_ON()
> empty DMA transfers') we return the wrong error value from scsi_prep_fn()
> back to the block layer.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
