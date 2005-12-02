From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 19:43:37 +0100
Message-ID: <9a8748490512021043o4c27a7c1o8e2cad0362a33dc6@mail.gmail.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
	 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
	 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org>
	 <20051201195657.GB7236@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
	 <20051202180326.GB7634@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750903AbVLBSnj@vger.kernel.org>
In-Reply-To: <20051202180326.GB7634@tau.solarneutrino.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Hugh Dickins <hugh@veritas.com>, Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/2/05, Ryan Richter <ryan@tau.solarneutrino.net> wrote:
[snip]
>
> Could someone please tell me exactly which patches I should include in
> the kernel I will boot tomorrow?  I haven't played with -rc for ages, so
> I'm no longer sure which kernel I should start with (2.6.14 or
> 2.6.14.3?).  Are the MPT-fusion performance fix patches in -rc4, or if
> not will they still apply?
>
The -rc patches apply to the base x.y.z kernel - in this case 2.6.14
For more info, read Documentation/applying-patches.txt in a recent
kernel source (or use this link:
http://sosdg.org/~coywolf/lxr/source/Documentation/applying-patches.txt
)


--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
