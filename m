From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Date: Mon, 24 Sep 2007 20:48:03 +0200
Message-ID: <64bb37e0709241148r58a99403k5f51f364de64eeb5@mail.gmail.com>
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923225320I.tomof@acm.org>
	 <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:53914 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbXIXSsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 14:48:04 -0400
Received: by an-out-0708.google.com with SMTP id d31so241152and
        for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2007 11:48:03 -0700 (PDT)
In-Reply-To: <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 9/23/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On 9/23/07, FUJITA Tomonori <tomof@acm.org> wrote:
> > Can you try Jens's sglist-arch branch? If it works, probably libata in
> > -mm has bugs.
> >
> > For your convenience, I put a sglist-arch branch patch against v2.6.23-rc7:
> >
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
>
> Thanks for the patch.
> I tried it and 3 out of 3 boot attempts worked without problems.
> But I can't rule out that the bug is still there, as I have no way to
> trigger it on demand.

Short update:
2 more boots with that kernel did also work.
I have just installed 2.6.23-rc7-mm1 and booted three times.
Also no problems with that version.

I will keep on using 2.6.23-rc7-mm1 and post again, if the error shows up again.

Torsten
