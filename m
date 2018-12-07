From: Eric Curtin <ericcurtin17@gmail.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 7 Dec 2018 13:39:54 +0000
Message-ID: <CANpvso4ZjJkUA7+saYRR4qssvreZcm-74EPo3nrGSohFZF9akA@mail.gmail.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5> <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com> <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com> <20181130221219.GA25537@linux.intel.com>
 <20181130151459.3ca2f5c8@lwn.net> <CAMuHMdUkpLWm5NZmYj=uMgVncw6ZOb7j9KxFoDGhrnr7vzpx_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUkpLWm5NZmYj=uMgVncw6ZOb7j9KxFoDGhrnr7vzpx_w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: geert@linux-m68k.org
Cc: corbet@lwn.net, jarkko.sakkinen@linux.intel.com, James.Bottomley@hansenpartnership.com, dave@stgolabs.net, keescook@chromium.org, Kernel development list <linux-kernel@vger.kernel.org>, amir73il@gmail.com, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, dja@axtens.net, davem@davemloft.net, linux@dominikbrodowski.net, dri-devel@lists.freedesktop.org, edumazet@google.com, federico.vaga@vaga.pv.it, geert+renesas@glider.be, deller@gmx.de, kumba@gentoo.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org, linux-mips@linux-mips.org, linux-mtd@lists.infradead.org, linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, matthias.bgg@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Guys,

I initially thought these patches were a joke. But I guess they are
not. I suppose 2018 is the year everything became offensive.

Could we avoid the s/fuck/hug/g though? I have nothing against
re-wording this stuff to remove the curse word, but it should at least
make sense.

What's going to happen is someone is a newbie is going to see a comment
like "We found an mark in the idr at the right wd, but it's not the
mark we were told to remove. eparis seriously hugged up somewhere",
probably google the term as they are unfamiliar with it, find out it's
an alias for "fucked" and if they are sensitive get offended anyway.

On Sat, 1 Dec 2018 at 08:20, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Jon,
>
> On Fri, Nov 30, 2018 at 11:15 PM Jonathan Corbet <corbet@lwn.net> wrote:
> > On Fri, 30 Nov 2018 14:12:19 -0800
> > Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > > As a maintainer myself (and based on somewhat disturbed feedback from
> > > other maintainers) I can only make the conclusion that nobody knows what
> > > the responsibility part here means.
> > >
> > > I would interpret, if I read it like at lawyer at least, that even for
> > > existing code you would need to do the changes postmorterm.
> > >
> > > Is this wrong interpretation?  Should I conclude that I made a mistake
> > > by reading the CoC and trying to understand what it *actually* says?
> > > After this discussion, I can say that I understand it less than before.
> >
> > Have you read Documentation/process/code-of-conduct-interpretation.rst?
> > As has been pointed out, it contains a clear answer to how things should
> > be interpreted here.
>
> Indeed:
>
> | Contributions submitted for the kernel should use appropriate language.
> | Content that already exists predating the Code of Conduct will not be
> | addressed now as a violation.
>
> However:
>
> | Inappropriate language can be seen as a
> | bug, though; such bugs will be fixed more quickly if any interested
> | parties submit patches to that effect.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
