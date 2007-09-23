From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Date: Sun, 23 Sep 2007 17:31:58 +0200
Message-ID: <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923225320I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070923225320I.tomof@acm.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On 9/23/07, FUJITA Tomonori <tomof@acm.org> wrote:
> On Sun, 23 Sep 2007 15:19:13 +0200
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > To update the statistik:
> > prior to 2.6.23-rc4-mm1: no trouble with any drives on the SiI 3132.
> > 2.6.23-rc4-mm1 without patch: 2 out of 2 bad.
> > back to 2.6.23-rc3-mm1: 18x good.
> > 2.6.23-rc4-mm1 with patch:  2 out of 8 bad
> > after that second mail:
> > 2.6.23-rc4-mm1 with patch: 1 out of 5 bad
> > 2.6.23-rc6-mm1: 1 out of 2 bad
>
> git-block.patch in 2.6.23-rc6-mm1 includes my patch that disables sg
> chaining for libata but it still includes libata's sg chaining
> changes. So these changes breaks libata or libata was broken after
> 2.6.23-rc3-mm1.
>
> Can you try Jens's sglist-arch branch? If it works, probably libata in
> -mm has bugs.
>
> For your convenience, I put a sglist-arch branch patch against v2.6.23-rc7:
>
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2

Thanks for the patch.
I tried it and 3 out of 3 boot attempts worked without problems.
But I can't rule out that the bug is still there, as I have no way to
trigger it on demand.

Torsten
