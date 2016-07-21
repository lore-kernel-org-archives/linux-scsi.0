From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Thu, 21 Jul 2016 08:00:43 +0200
Message-ID: <24e83314-a4fa-76de-04ee-43b7b50cbbd2@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-7-git-send-email-hare@suse.de>
 <20160721055351.GA14568@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160721055351.GA14568@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 07/21/2016 07:53 AM, Christoph Hellwig wrote:
> On Tue, Jul 19, 2016 at 03:20:39PM +0200, Hannes Reinecke wrote:
>> Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
>> without error.
>=20
> NAK.  You can just do a blk_mq_end_request on the request and return
> 0 from ->queue_rq.
>=20
Okay, will be doing so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-block" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
