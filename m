From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 12 Jan 2004 16:07:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <OF317B32D5.C8C681CB-ONC1256E19.005066CF-C1256E19.00538DEF@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Jens Axboe <axboe@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Arjan Van de Ven <arjanv@redhat.com>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de
List-Id: linux-scsi@vger.kernel.org


Hi,

I understand that people tend to be careful with optimizations
or enhancements. In that regard, this particular patch is a
disputable example.

But, my request has been meant in a broader sense.
This iorl-patch is just one out of roughly a dozen on
both RH's side and SuSE's side. I have been asking
for getting together on the list and trying to match and merge
these piles of patches, which are possibly not all as disputable
as the patch discussed in this thread, i.e. pure (partially
vintage) bugfixes.

If people agree in that course also about a clean, common
iorl-patch, that would be another step forward, in my opinion.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Jens Axboe <axboe@suse.de>@vger.kernel.org on 12/01/2004 15:13:30

Sent by:    linux-scsi-owner@vger.kernel.org


To:    Martin Peschke3/Germany/IBM@IBMDE
cc:    Doug Ledford <dledford@redhat.com>, Arjan Van de Ven
       <arjanv@redhat.com>, Peter Yao <peter@exavio.com.cn>,
       linux-kernel@vger.kernel.org, linux-scsi mailing list
       <linux-scsi@vger.kernel.org>
Subject:    Re: smp dead lock of io_request_lock/queue_lock patch


On Mon, Jan 12 2004, Martin Peschke3 wrote:
> Hi,
>
> is there a way to merge all (or at least the common denominator) of
> Redhat's and SuSE's changes into the vanilla 2.4 SCSI stack?
> The SCSI part of Marcelo's kernel seems to be rather backlevel,
> considering all those fixes and enhancements added by the mentioned
> distributors and their SCSI experts. As this discussion underlines,
> there are a lot of common problems and sometimes even common
> approaches.  I am convinced that a number of patches ought to be
> incorporated into the mainline kernel. Though, I must admit
> that I am at a loss with how this could be achieved given the
> unresolved question of 2.4 SCSI maintenance
> (which has certainly played a part in building up those piles
> of SCSI patches).

I have mixed feelings about that. One on side, I'd love to merge the
scalability patches in mainline. We've had a significant number of bugs
in this area in the past, and it seems a shame that we all have to fix
them independently because we deviate from mainline. On the other hand,
2.4 is pretty much closed. There wont be a big number of new distro 2.4
kernels.

Had you asked me 6 months ago I probably would have advocated merging
them, but right now I think it's a waste of time.

--
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
