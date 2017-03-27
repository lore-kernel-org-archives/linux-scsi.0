From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: =?iso-8859-5?Q?Re:_[PATCH_1/7]_=F5d:_split_sd=5Fsetup=5Fdiscard=5Fcmnd?=
Date: Mon, 27 Mar 2017 22:24:47 +0000
Message-ID: <1490653474.7897.13.camel@sandisk.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170320204319.12628-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-5"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60099 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdC0WY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 18:24:56 -0400
In-Reply-To: <20170320204319.12628-2-hch@lst.de>
Content-Language: en-US
Content-ID: <7C6B7B6D4194D04D947A7D62FD63CB86@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> +	u64 sector =3D blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
> +	u32 nr_sectors =3D blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);

Although I know this is an issue in the existing code and not something
introduced by you: please consider using logical_to_sectors() instead of
open-coding this function. Otherwise this patch looks fine to me.

Thanks,

Bart.
