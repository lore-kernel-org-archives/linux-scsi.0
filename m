From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: Thu, 6 Feb 2003 13:02:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302061300430.7389-100000@home.transmeta.com>
References: <1044565217.14310.253.camel@spc9.esa.lanl.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1044565217.14310.253.camel@spc9.esa.lanl.gov>
To: Steven Cole <elenstev@mesatop.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 6 Feb 2003, Steven Cole wrote:
> 
> In this case the issue is not a broken mailer, but rather the improper
> use of a good one.  Mark is using Evolution and so am I.  It appears
> that he did a cut and paste from an xterm (or something similar) which
> converted the tabs to spaces.

Ahh, yes. That would also do it.

[ I'm also happy to hear that Evolution does it right these days, I have
  this memory of it pruning whitespace at ends of lines by default like
  some broken versions of pine also did. But maybe it was some other
  graphical mail client. ]

Anyway, applied.

		Linus
