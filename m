From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v5] SCSI host lock push-down
Date: Tue, 16 Nov 2010 17:36:52 +0000
Message-ID: <1289929012.11405.12.camel@mulgrave.site>
References: <1289606118.3015.539.camel@mulgrave.site>
	 <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
	 <20101113051635.GA11613@havoc.gtf.org>
	 <20101116071029.GA13540@havoc.gtf.org>
	 <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-11-16 at 09:25 -0800, Linus Torvalds wrote:
> On Mon, Nov 15, 2010 at 11:10 PM, Jeff Garzik <jeff@garzik.org> wrote:
> >
> > Move the mid-layer's ->queuecommand() invocation from being locked
> > with the host lock to being unlocked to facilitate speeding up the
> > critical path for drivers who don't need this lock taken anyway.
> 
> Looks ok to me. How should I take this? Just as a patch? Or should it
> go through the scsi tree?

I was thinking through next for a few days to see if anything breaks in
the architectures with scsi drivers we can't compile on x86 ... but
realistically that will happen in -rcX as well, so I'm happy either way.

James
