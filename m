From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Thu, 15 Mar 2012 13:01:08 -0400
Message-ID: <20120315170108.GA8638@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
 <CAH+dOx+Vgv12w=Q=8hCQggLg+kq6TnT2i3ZtnpZ=bNVyMgk31Q@mail.gmail.com>
 <CAAsGZS5UTrYTbncAjk1Vor6R_-KWDboTw3sh+jXCbXm5q_o-TA@mail.gmail.com>
 <CAH+dOx+M5so=YOx=O2vUjpdHsG+oiGsJh3GouoVq+twL+tO3Yw@mail.gmail.com>
 <CAAsGZS5ODjG9EmfnYdkEejqptVa9u4EL32cb_mZB5oJ3Dfi=vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fa0-f46.google.com ([209.85.161.46]:37160 "EHLO
	mail-fa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab2CORBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 13:01:13 -0400
Received: by faas1 with SMTP id s1so622156faa.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 10:01:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAAsGZS5ODjG9EmfnYdkEejqptVa9u4EL32cb_mZB5oJ3Dfi=vg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 03:04:52PM -0400, chetan loke wrote:
> On Wed, Mar 14, 2012 at 2:41 PM, Kent Overstreet <koverstreet@google.com> wrote:
> > If you want me to implement bcache differently, shouldn't you explain why
> 
> relax. I explained it already but you are defensive about your code.
> flash-cache works, period. And I may be wrong but it is GPL'd. If perf
> is an issue then atleast let everyone know how it can be improved
> rather than saying my way or the highway. aren't you saying in your
> patches - support for thin prov etc. but if dm provides it then why
> are you duplicating code?

I'm not defensive about my code; you asked why someone would be
interested in bcache vs. flash cache, and performance is the most
obvious reason. Seems kind of ridiculous to then accuse me of being
defensive.

If you want to know how the performance of flash cache can be improved,
bcache's design is documented and the code is available. I'm not
interested in flash cache and improving it isn't my job; furthermore
bcache's performance comes from fundamental design decisions so I don't
think flash cache is ever going to approach bcache's performance.

> > why? I'm not sure why I _have_ to justify my decisions to you.
> 
> Others might want to contribute to it and not just consume it. This
> ain't your local sandbox. So it's quite common to get such questions
> when you are trying to add new functionality. May be I missed some of
> your emails. If so point me to them.

Helping others get involved is rather different - I'm perfectly fine to
help anyone who's interested, and I spent quite a lot of time
documenting and explaining the code, and helping users out.

But I'm just not interested in justifying bcache's existince vs.
flashcache. If you like flashcache better, it's no skin off my back.
