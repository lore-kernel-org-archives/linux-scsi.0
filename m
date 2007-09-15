From: Paul Jackson <pj@sgi.com>
Subject: Re: 2.6.23-rc4-mm1
Date: Fri, 14 Sep 2007 21:16:35 -0700
Message-ID: <20070914211635.4774c971.pj@sgi.com>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070910174926.GC30335@shadowen.org>
	<20070910111926.9c942358.akpm@linux-foundation.org>
	<20070910042256Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760230AbXIOEQx@vger.kernel.org>
In-Reply-To: <20070910042256Z.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: apw@shadowen.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Can you try this patch (against 2.6.23-rc4-mm1)?
> 
> >From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 10 Sep 2007 04:17:13 +0100
> Subject: [PATCH] qla1280: sg chaining fixes
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/qla1280.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

This patch works for me.

I was getting the scsi errors reported earlier in
this thread, running 2.6.23-rc4-mm1 on one of our
big SGI Altix systems.

Applying this patch fixed it, so far as I can tell,
which is to say my system boots cleanly once again.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
