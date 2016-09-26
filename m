From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Mon, 26 Sep 2016 18:58:55 -0500
Message-ID: <CAJVOszBqGDFrqkHiddMGwWoe1JOdar-BMq4O2pKJAhQ_ZcHYEg@mail.gmail.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
 <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com>
 <20160926163752.GA13876@infradead.org> <61629301-8347-f217-8d74-d38b312f7c21@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <61629301-8347-f217-8d74-d38b312f7c21@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

No objection here.

On Mon, Sep 26, 2016 at 6:30 PM, Damien Le Moal <damien.lemoal@hgst.com> wr=
ote:
>
> Christoph,
>
> On 9/27/16 01:37, Christoph Hellwig wrote:
>>> -/*
>>> - * Zone type.
>>> - */
>>> -enum blk_zone_type {
>>> -    BLK_ZONE_TYPE_UNKNOWN,
>>> -    BLK_ZONE_TYPE_CONVENTIONAL,
>>> -    BLK_ZONE_TYPE_SEQWRITE_REQ,
>>> -    BLK_ZONE_TYPE_SEQWRITE_PREF,
>>> -};
>>
>> Please don't move this code around after it was added just two
>> patches earlier.  I'd say just split adding the new blkzoned.h
>> uapi header into a patch of it's own and add that before the
>> core block code.
>
> Or we could just simply merge patches 5 and 7... Even more simple.
> Would that be OK ? Shaun, any objection ?
>
> Best regards.
>
> --
> Damien Le Moal, Ph.D.
> Sr. Manager, System Software Group, HGST Research,
> HGST, a Western Digital brand
> Damien.LeMoal@hgst.com
> (+81) 0466-98-3593 (ext. 513593)
> 1 kirihara-cho, Fujisawa,
> Kanagawa, 252-0888 Japan
> www.hgst.com
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality=
 Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or=
 legally privileged information of WDC and/or its affiliates, and are inten=
ded solely for the use of the individual or entity to which they are addres=
sed. If you are not the intended recipient, any disclosure, copying, distri=
bution or any action taken or omitted to be taken in reliance on it, is pro=
hibited. If you have received this e-mail in error, please notify the sende=
r immediately and delete the e-mail in its entirety from your system.
>



--=20
Shaun Tancheff
