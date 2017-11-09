From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v11 0/7] block, scsi, md: Improve suspend and resume
Date: Thu, 09 Nov 2017 18:10:29 +0100
Message-ID: <2843000.pAMepr1eOs@natalenko.name>
References: <20171030224205.25212-1-bart.vanassche@wdc.com> <1510246471.2608.11.camel@wdc.com> <5e91482c-16f5-13c8-e42d-cbe8dda355ad@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5e91482c-16f5-13c8-e42d-cbe8dda355ad@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Then,

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

On =C4=8Dtvrtek 9. listopadu 2017 17:55:58 CET Jens Axboe wrote:
> On 11/09/2017 09:54 AM, Bart Van Assche wrote:
> > On Thu, 2017-11-09 at 07:16 +0100, Oleksandr Natalenko wrote:
> >> is this something known to you, or it is just my fault applying this
> >> series to v4.13? Except having this warning, suspend/resume works for
> >> me:
> >>=20
> >> [   27.383846] sd 0:0:0:0: [sda] Starting disk
> >> [   27.383976] sd 1:0:0:0: [sdb] Starting disk
> >> [   27.451218] sdb: Attempt to allocate non-preempt request in
> >> preempt-only
> >> mode.
> >> [   27.459640] ------------[ cut here ]------------
> >> [   27.464521] WARNING: CPU: 0 PID: 172 at block/blk-core.c:823
> >> blk_queue_enter+0x222/0x280>=20
> > Hello Oleksandr,
> >=20
> > Thanks for the testing. The warning that you reported is expected. Maybe
> > it
> > should be left out to avoid that users get confused.
>=20
> If the warning is expected, then it should be removed. It'll just confuse
> users and cause useless bug reports.
>=20
> > Jens, this patch series still applies cleanly on top of your
> > for-4.15/block
> > branch. Are you fine with this patch series or do you perhaps want me to
> > repost it with Oleksandr's Tested-by tag added to each patch?
>=20
> Since you need to kill the warning anyway, let's get it respun.
