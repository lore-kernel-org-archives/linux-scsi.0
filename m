From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [stable-4.14 00/23] block/scsi multiqueue performance enhancement and
Date: Mon, 23 Jul 2018 17:37:40 +0200
Message-ID: <CA+res+RSPJ326FWvH5e6ROx1rdHMBTses8vgEBJ72sOMrHjiOA@mail.gmail.com>
References: <1532352285-13589-1-git-send-email-jinpuwang@gmail.com>
 <20180723133356.GA1333@kroah.com> <CA+res+TE5-mgnQys67zQ8cqRyv+dgNPpTFLOEq81t2izpq1dsw@mail.gmail.com>
 <f67eedb1-e78e-36a9-b3f5-f2192e9d079a@kernel.dk> <CA+res+Txma6FcZtCZ4yhWiQgRJY+0b8BdgJ67uzYodfDyevC-g@mail.gmail.com>
 <0c2c50c4-3a17-c0cd-6ece-4f2ca6e30dde@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <0c2c50c4-3a17-c0cd-6ece-4f2ca6e30dde@kernel.dk>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Wang Jinpu <xjtuwjp@gmail.com>, stable@vger.kernel.org, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2018=E5=B9=B47=E6=9C=8823=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:31=E5=86=99=E9=81=93=EF=BC=9A
>
> On 7/23/18 9:28 AM, Jack Wang wrote:
> > Jens Axboe <axboe@kernel.dk> =E4=BA=8E2018=E5=B9=B47=E6=9C=8823=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:05=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On 7/23/18 9:00 AM, Jack Wang wrote:
> >>> Hi Greg,
> >>>
> >>> Thanks for quick reply. Please see reply inline.
> >>>
> >>>
> >>>
> >>> Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2018=E5=B9=B47=E6=9C=88=
23=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:34=E5=86=99=E9=81=93=EF=
=BC=9A
> >>>>
> >>>> On Mon, Jul 23, 2018 at 03:24:22PM +0200, Jack Wang wrote:
> >>>>> Hi Greg,
> >>>>>
> >>>>> Please consider this patchset, which include block/scsi multiqueue =
performance
> >>>>> enhancement and bugfix.
> >>>>
> >>>> What exactly is the performance enhancement?  How can you measure it=
?
> >>>> How did you measure it?
> >>> I'm testing on SRP/IBNBD using fio, I've seen +10% with mix IO load,
> >>> and 50% improvement on small IO (bs=3D512.) with the patchset.
> >>
> >> Big nak on backporting this huge series, it's a lot of core changes.
> >> It's way beyond the scope of a stable fix backport.
> >>
> >> --
> >> Jens Axboe
> >>
> > OK, could you shed light on how could we fix the queue stall problem on=
 4.14?
> > My colleague Roman reported to upstream:
> > https://lkml.org/lkml/2017/10/18/263
> >
> > It's still there on latest 4.14.
>
> The proposed patch is a helluva lot simpler than doing a 23 patch selecti=
ve
> backport.
>
> --
> Jens Axboe
>
Do you think it make sense to port Roman's patch to upstream 4.14?

So others would also be benifitial?
On the other side, stable tree only takes patches accepted into Linus tree.

Thanks,
Jack
