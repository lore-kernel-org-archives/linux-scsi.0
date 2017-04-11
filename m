From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH RESEND] scsi: return correct blkprep status code in case
 scsi_init_io() fails.
Date: Tue, 11 Apr 2017 18:43:22 +0000
Message-ID: <1491936200.2654.18.camel@sandisk.com>
References: <20170411074644.6071-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52843 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdDKSn1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 14:43:27 -0400
In-Reply-To: <20170411074644.6071-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <49A7269491C3D94DB3E4901E387E0B6D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-11 at 09:46 +0200, Johannes Thumshirn wrote:
> When instrumenting the SCSI layer to run into the
> !blk_rq_nr_phys_segments(rq) case the following  warning emitted from the
> block layer:
>=20
> blk_peek_request: bad return=3D-22
>=20
> This happens because since commit fd3fc0b4d730 ('scsi: don't BUG_ON()
> empty DMA transfers') we return the wrong error value from iscsi_prep_fn(=
)
                                                             ^^^^^^^^^^^^^^=
^
There is no=A0iscsi_prep_fn() in the kernel tree. Did you perhaps mean
scsi_prep_fn()?

> back to the block layer.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: fd3fc0b4d730 scsi: don't BUG_ON() empty DMA transfers
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Commit fd3fc0b4d730 has a "Cc: stable" tag. I assume that that means that
this patch also needs that tag?

Otherwise this patch looks fine to me.

Bart.=
