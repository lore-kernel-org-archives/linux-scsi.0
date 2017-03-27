From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [Drbd-dev] RFC: always use REQ_OP_WRITE_ZEROES for zeroing
 offload
Date: Mon, 27 Mar 2017 15:08:16 +0000
Message-ID: <1490627281.2461.4.camel@sandisk.com>
References: <20170323143341.31549-1-hch@lst.de>
         <20170323155410.GD1138@soda.linbit> <20170327091056.GB6879@infradead.org>
         <20170327140307.GA13020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7001 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbdC0PJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 11:09:09 -0400
In-Reply-To: <20170327140307.GA13020@redhat.com>
Content-Language: en-US
Content-ID: <631697B4B3796943B829130DF7C39672@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "shli@kernel.org" <shli@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Mon, 2017-03-27 at 10:03 -0400, Mike Snitzer wrote:
> As for the blkdev_issue_zeroout() resorting to manually zeroing the
> range, if the discard fails or dzd not supported, that certainly
> requires DM thinp to implement manual zeroing of the head and tail of
> the range if partial blocks are being zeroed.  So I welcome any advances
> there.  It is probably something that is best left to Joe or myself to
> tackle.  But I'll gladly accept patches ;)

Some time ago I posted a patch series for the block layer that zeroes
start and tail for nonaligned discard requests if dzd has been set. See
also "[PATCH v3 0/5] Make blkdev_issue_discard() submit aligned discard
requests" (https://www.spinics.net/lists/linux-block/msg02360.html).

Bart.=
