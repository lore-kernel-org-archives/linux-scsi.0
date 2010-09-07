From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Mon, 6 Sep 2010 23:45:05 -0400
Message-ID: <AANLkTikxeV3yVXcnKgZCiORyzZ8xR4Ydxf2rbquvRcJ=@mail.gmail.com>
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	<4C7FFD1A.8090509@vlnb.net>
	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	<20100905201802.GC18411@core.coreip.homeip.net>
	<1283723447.556.133.camel@haakon2.linux-iscsi.org>
	<20100905234134.GA17212@core.coreip.homeip.net>
	<1283731194.556.147.camel@haakon2.linux-iscsi.org>
	<1283769578.15944.1293.camel@mulgrave.site>
	<4C85617E.2080603@vlnb.net>
	<1283810135.556.238.camel@haakon2.linux-iscsi.org>
	<20100907004424.GB21430@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100907004424.GB21430@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 6, 2010 at 8:44 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> I think this is somewhat backwards...
>
> Vlad appears to be asserting that SCST is more feature-complete that LIO
> at this point. It also seems that LIO is somewhat younger than SCST. So
> at this point it might be interesting to see:
>
> 1. What are the shortcomings of SCST design compared to LIO and why LIO
> developers chose to come with their own solution instead of
> collaborating with SCST folks?
>
> 2. What features are missing from SCST that are currently available in
> LIO?
>
> Once this is sorted out and [most] everyone agrees that LIO is indeed
> technically superior (even if maybe not as mature yet) solution, then it
> would make sense to request SCST developers to go to file/line depth of
> the review.
>

I would also appreciate an overview or a block diagram of how things
work in LIO. I hope that's not too much to ask for? That way we can
compare/contrast how things work from 10,000 feet level.
I for one don't want to look at a single patch and comment -
i) Oh, change this variable here because it doesn't follow linux coding style.
ii) You dropped a lock in queue-cmd? Good. qla's driver has been doing
it for sometime, no? So you could have just looked at that LLDD.

Sorry, not trying to criticize anything but would like to offer my 2 cents too.

> --
> Dmitry

Chetan Loke
