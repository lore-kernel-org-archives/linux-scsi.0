From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: scsi target, likely GPL violation
Date: Fri, 9 Nov 2012 11:03:36 +0000
Message-ID: <20121109110336.41833034@pyramind.ukuu.org.uk>
References: <509A915B.30105@redhat.com>
	<CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	<509B117A.6070708@genband.com>
	<509BE460.6010404@redhat.com>
	<1352405111.29589.476.camel@haakon2.linux-iscsi.org>
	<509C22B2.8010600@redhat.com>
	<1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Andy Grover <agrover@redhat.com>, Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

> For our commercial target core, we only use Linux kernel symbols that
> are not marked as GPL. In addition, we define the API between the target

And this has what meaning ?

The Linux kernel is a GPL work, any derivative work is a GPL work. The
symbol tags are just a guidance.

You do not have permission to build a non GPL derivative work of any code
I own. The licensing determination is *derivative work* not symbols
marked with _GPL. This has been stated publically by many developers many
times.

So either your work is truely not derivative of the kernel (which I find
wildly improbable) or you have a problem and since you are aware of the
complaints publically I guess probably a triple damages sized problem. But
that's one for your lawyers and whatever opinion they have on the subject.

You do btw have a second thing to consider - there are US patent grants
for some functions in the kernel that only extend to GPL code so utilising
some of the subsystems in the USA may give you other problems even if you
can somehow manage to demonstrate your work is not derivative.

> RTS OS is based on a stock Linux enterprise kernel. This Linux kernel
> has naturally the ability to load either one of our standalone
> self-contained target module versions without any modifications.

That's not the usual test for derivative work I've heard applied.

I fail to understand the maintainer question however. If you were trying
to block people adding target features that competed that would be a
different thing.

Alan
