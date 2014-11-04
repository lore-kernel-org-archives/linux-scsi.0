From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Wed, 5 Nov 2014 12:36:02 +1300
Message-ID: <CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<5455C107.6040500@gmail.com>
	<alpine.LNX.2.00.1411021710210.27266@nippy.intranet>
	<5455E340.7080305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5455E340.7080305@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,


> Thanks for testing.
>
> "No regressions over v1" means "no regressions", right?
>
>
>
> Well, what would I compare the driver performance to? With your patches to
> sort out locking races, the driver is more stable than I've ever seen it in
> years. That's a definite win. Big improvement over the driver in its current
> state in m68k and mainstream (which locks up quite reliably with even
> moderate concurrent IDE and SCSI I/O for me). No regression over v1 or
> patches that you sent for me to test off-list.
>
> On the other hand, I've seen warnings about lost bytes (stuck in the DMA
> fifo) for the first time _ever_ with the new driver - we've discussed that
> at length, and it is still unclear why these happen. This is a known NCR5380
> issue, and pretty much anything could have precipitated that. Must have
> happened for other Falcon users before in the past, because the interrupt
> handler explicitly checks for this condition.

I went back and checked test logs from driver tests before any of your
patches - no regressions over vanilla 3.17 or 3.16.

The 'lost bytes' error is rare enough that it would not have shown in
those tests. Vanilla kernels run into the ST-DMA locking race at about
7% of the total test set.

The last kernel that performed with a similar stability as with your
patches was 2.4.30 or thereabouts.

Cheers,

  Michael
