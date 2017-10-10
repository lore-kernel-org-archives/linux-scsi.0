From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O performance(part 1)
Date: Tue, 10 Oct 2017 14:37:46 +0200
Message-ID: <ABF5B287-B957-425D-A395-BA42A2D8421D@linaro.org>
References: <20170930102720.30219-1-ming.lei@redhat.com> <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com> <20171009150439.GA30189@ming.t460p> <20171010014653.GA3247@ming.t460p> <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com> <20171010123439.7lzndy5qcjtmd56y@linux-x5ow.site>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171010123439.7lzndy5qcjtmd56y@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org


> Il giorno 10 ott 2017, alle ore 14:34, Johannes Thumshirn =
<jthumshirn@suse.de> ha scritto:
>=20
> Hi John,
>=20
> On Tue, Oct 10, 2017 at 01:24:52PM +0100, John Garry wrote:
>> It's using cfq (for non-mq) and mq-deadline (obviously for mq).
>=20
> Please be aware that cfq and mq-deadline are _not_ comparable, for a =
realistic
> comparasion please use deadline and mq-deadline or cfq and bfq.
>=20

Please set low_latency=3D0 for bfq if yours is just a maximum-throughput =
test.

Thanks,
Paolo

>> root@(none)$ pwd
>> =
/sys/devices/platform/HISI0162:01/host0/port-0:0/expander-0:0/port-0:0:7/e=
nd_device-0:0:7
>> root@(none)$ more ./target0:0:3/0:0:3:0/block/sdd/queue/scheduler
>> noop [cfq]
>=20
> Maybe missing CONFIG_IOSCHED_DEADLINE?
>=20
> Thanks,
> 	Johannes
>=20
> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
