From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/23] block: renumber REQ_OP_WRITE_ZEROES
Date: Tue, 28 Mar 2017 16:12:46 +0000
Message-ID: <1490717553.2573.4.camel@sandisk.com>
References: <20170323143341.31549-1-hch@lst.de>
         <20170323143341.31549-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:1441 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbdC1QN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 12:13:27 -0400
In-Reply-To: <20170323143341.31549-2-hch@lst.de>
Content-Language: en-US
Content-ID: <B160B454ABBE5B4E8E2058151862CA8C@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

On Thu, 2017-03-23 at 10:33 -0400, Christoph Hellwig wrote:
> Make life easy for implementations that needs to send a data buffer
> to the device (e.g. SCSI) by numbering it as a data out command.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blk_types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d703acb55d0f..6393c13a6498 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -160,7 +160,7 @@ enum req_opf {
>  	/* write the same sector many times */
>  	REQ_OP_WRITE_SAME	=3D 7,
>  	/* write the zero filled sector many times */
> -	REQ_OP_WRITE_ZEROES	=3D 8,
> +	REQ_OP_WRITE_ZEROES	=3D 9,
> =20
>  	/* SCSI passthrough using struct scsi_request */
>  	REQ_OP_SCSI_IN		=3D 32,

Hello Christoph,

Since REQ_OP_WRITE_ZEROES was introduced in kernel v4.10, do we need
"Cc: stable" and "Fixes: a6f0788ec2881" tags for this patch?

Thanks,

Bart.=
