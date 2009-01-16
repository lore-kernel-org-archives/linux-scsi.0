From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 15:03:12 +1100
Message-ID: <200901161503.13730.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901151824.38658.nickpiggin@yahoo.com.au> <20090115162735.99277cc9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25933 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754282AbZAPEDl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 23:03:41 -0500
In-Reply-To: <20090115162735.99277cc9.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: matthew@wil.cx, matthew.r.wilcox@intel.com, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com

On Friday 16 January 2009 11:27:35 Andrew Morton wrote:
> On Thu, 15 Jan 2009 18:24:36 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Given that SLAB and SLUB are fairly mature, I wonder what you'd think of
> > taking SLQB into -mm and making it the default there for a while, to see
> > if anybody reports a problem?
>
> Nobody would test it in interesting ways.
>
> We'd get more testing in linux-next, but still not enough, and not of
> the right type.

It would be better than nothing, for SLQB, I guess.


> It would be better to just make the desision, merge it and forge ahead.
>
> Me, I'd be 100% behind the idea if it had a credible prospect of a net
> reduction in the number of slab allocator implementations.

>From the data we have so far, I think SLQB is a "credible prospect" to
replace SLUB and SLAB. But then again, apparently SLUB was a credible
prospect to replace SLAB when it was merged.

Unfortunately I can't honestly say that some serious regression will not
be discovered in SLQB that cannot be fixed. I guess that's never stopped
us merging other rewrites before, though.

I would like to see SLQB merged in mainline, made default, and wait for
some number releases. Then we take what we know, and try to make an
informed decision about the best one to take. I guess that is problematic
in that the rest of the kernel is moving underneath us. Do you have
another idea?


> I guess the naming convention will limit us to 26 of them.  Fortunate
> indeed that the kernel isn't written in cyrillic!

I could have called it SL4B. 4 would be somehow fitting...

