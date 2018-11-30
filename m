From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 14:12:19 -0800
Message-ID: <20181130221219.GA25537@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com>
 <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1543615069.3031.27.camel@HansenPartnership.com>
Sender: netdev-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Axtens <dja@axtens.net>, "David S. Miller" <davem@davemloft.net>, Dominik Brodowski <linux@dominikbrodowski.net>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it, Geert Uytterhoeven <geert+renesas@glider.be>, Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>, Joshua Kinard <kumba@gentoo.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>linux-
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 30, 2018 at 01:57:49PM -0800, James Bottomley wrote:
> On Fri, 2018-11-30 at 13:44 -0800, Jarkko Sakkinen wrote:
> > On Fri, Nov 30, 2018 at 01:01:02PM -0800, James Bottomley wrote:
> > > No because use of what some people consider to be bad language
> > > isn't necessarily abusive, offensive or degrading.  Our most
> > > heavily censored medium is TV and "fuck" is now considered
> > > acceptable in certain contexts on most channels in the UK and EU.
> > 
> > This makes following the CoC extremely hard to a non-native speaker
> > as it is not too explicit on what is OK and what is not. I did
> > through the whole thing with an eye glass and this what I deduced
> > from it.
> 
> OK, so something that would simply be considered in some quarters as
> bad language isn't explicitly banned.  The thing which differentiates
> simple bad language from "abusive, offensive or degrading language",
> which is called out by the CoC, is the context and the target.
> 
> So when it's a simple expletive or the code of the author or even the
> hardware is the target, I'd say it's an easy determination it's not a
> CoC violation.  If someone else's code is the target or the inventor of
> the hardware is targetted by name, I'd say it is.  Even non-native
> English speakers should be able to determine target and context,
> because that's the essence of meaning.

I pasted this already to another response and this was probably the part
that ignited me to send the patch set (was a few days ago, so had to
revisit to find the exact paragraph):

"Maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other
contributions that are not aligned to this Code of Conduct, or to ban
temporarily or permanently any contributor for other behaviors that they
deem inappropriate, threatening, offensive, or harmful."

The whole patch set is neither a joke/troll nor something I would
necessarily want to be include myself. It does have the RFC tag.

As a maintainer myself (and based on somewhat disturbed feedback from
other maintainers) I can only make the conclusion that nobody knows what
the responsibility part here means.

I would interpret, if I read it like at lawyer at least, that even for
existing code you would need to do the changes postmorterm.

Is this wrong interpretation?  Should I conclude that I made a mistake
by reading the CoC and trying to understand what it *actually* says?
After this discussion, I can say that I understand it less than before.

/Jarkko
