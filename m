From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Wed, 14 Mar 2012 15:04:52 -0400
Message-ID: <CAAsGZS5ODjG9EmfnYdkEejqptVa9u4EL32cb_mZB5oJ3Dfi=vg@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
	<CAAsGZS6Jw8xCdu3Wuve=iaKpd_UNdm72kbTbiQtypAfrZ46PWw@mail.gmail.com>
	<CAH+dOx+Vgv12w=Q=8hCQggLg+kq6TnT2i3ZtnpZ=bNVyMgk31Q@mail.gmail.com>
	<CAAsGZS5UTrYTbncAjk1Vor6R_-KWDboTw3sh+jXCbXm5q_o-TA@mail.gmail.com>
	<CAH+dOx+M5so=YOx=O2vUjpdHsG+oiGsJh3GouoVq+twL+tO3Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38430 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2CNTEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 15:04:52 -0400
Received: by yenl12 with SMTP id l12so2154666yen.19
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 12:04:52 -0700 (PDT)
In-Reply-To: <CAH+dOx+M5so=YOx=O2vUjpdHsG+oiGsJh3GouoVq+twL+tO3Yw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 2:41 PM, Kent Overstreet <koverstreet@google.com> wrote:
> If you want me to implement bcache differently, shouldn't you explain why

relax. I explained it already but you are defensive about your code.
flash-cache works, period. And I may be wrong but it is GPL'd. If perf
is an issue then atleast let everyone know how it can be improved
rather than saying my way or the highway. aren't you saying in your
patches - support for thin prov etc. but if dm provides it then why
are you duplicating code?

> why? I'm not sure why I _have_ to justify my decisions to you.

Others might want to contribute to it and not just consume it. This
ain't your local sandbox. So it's quite common to get such questions
when you are trying to add new functionality. May be I missed some of
your emails. If so point me to them.
