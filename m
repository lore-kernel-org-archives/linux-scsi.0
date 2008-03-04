From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 13:58:35 +0100
Message-ID: <1204635515.17258.12.camel@homer.simson.net>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
	 <1204634619.17258.0.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1204634619.17258.0.camel@homer.simson.net>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-03-04 at 13:43 +0100, Mike Galbraith wrote:

> > can you please try git as of this morning without any patches applied,
> > and then pull
> > 
> > git://git.kernel.dk/linux-2.6-block.git for-linus
> > 
> > into that and see if that works?
> 
> I'll give it a shot in a bit.

Aw poo, so many choices.
I did:
	git add remote block-for-linus git://git.kernel.dk/linux-2.6-block.git
	git remote update
Now, which one do I check out?  block-for-linus/master maybe, or
block-for-linus/for-linus?

homer:..git/linux-2.6 # git checkout block-for-linus
error: pathspec 'block-for-linus' did not match any file(s) known to git.
Did you forget to 'git add'?
homer:..git/linux-2.6 # git branch -a
* master
  x86/master
  x86/mm
  block-for-linus/blktrace
  block-for-linus/cmdfilter
  block-for-linus/dynpipe
  block-for-linus/fcache
  block-for-linus/for-akpm
  block-for-linus/for-linus
  block-for-linus/io-cpu-affinity
  block-for-linus/io-cpu-affinity-kthread
  block-for-linus/loop-extent_map
  block-for-linus/loop-fastfs
  block-for-linus/master
  block-for-linus/plug
  block-for-linus/splice
  block-for-linus/syslet
  block-for-linus/syslet-share
  block-for-linus/timeout
  linux-next/master
  linux-next/stable
  origin/HEAD
  origin/master
  x86/base
  x86/for-akpm
  x86/for-linus
  x86/latest
  x86/master
  x86/mm
  x86/origin
  x86/testing


