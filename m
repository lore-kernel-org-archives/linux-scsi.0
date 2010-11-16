From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v5] SCSI host lock push-down
Date: Tue, 16 Nov 2010 15:32:38 -0600
Message-ID: <1289943158.11405.261.camel@mulgrave.site>
References: <1289606118.3015.539.camel@mulgrave.site>
	 <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
	 <20101113051635.GA11613@havoc.gtf.org>
	 <20101116071029.GA13540@havoc.gtf.org>
	 <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
	 <1289929012.11405.12.camel@mulgrave.site>
	 <AANLkTinBZ9dEHVB9zc89RuBc-d3S2TSn9UAQT7zJbdeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinBZ9dEHVB9zc89RuBc-d3S2TSn9UAQT7zJbdeQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-11-16 at 13:30 -0800, Linus Torvalds wrote:
> On Tue, Nov 16, 2010 at 9:36 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> >
> > I was thinking through next for a few days to see if anything breaks in
> > the architectures with scsi drivers we can't compile on x86 ... but
> > realistically that will happen in -rcX as well, so I'm happy either way.
> 
> I really just wanted a firm "just take the patch" or "wait for a
> pull", so that I can forget about this issue either way.
> 
> But it sounds like I have an ack for you, so I might as well just take
> the patch.

You do ... if you need it formally:

Acked-by: James Bottomley <James.Bottomley@suse.de>

James
