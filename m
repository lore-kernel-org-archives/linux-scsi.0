From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 14:04:09 -0800
Message-ID: <1543615449.3031.32.camel@HansenPartnership.com>
References: <20181130205521.GA21006@linux.intel.com>
         <1543611662.3031.20.camel@HansenPartnership.com>
         <20181130214405.GG23772@linux.intel.com>
         <20181130.134808.1785785556132211918.davem@davemloft.net>
         <20181130215429.GA24415@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130215429.GA24415@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, David Miller <davem@davemloft.net>
Cc: dave@stgolabs.net, keescook@chromium.org, linux-kernel@vger.kernel.org, amir73il@gmail.com, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, dja@axtens.net, linux@dominikbrodowski.net, dri-devel@lists.freedesktop.org, edumazet@google.com, federico.vaga@vaga.pv.it, geert+renesas@glider.be, deller@gmx.de, corbet@lwn.net, kumba@gentoo.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org, linux-mips@linux-mips.org, linux-mtd@lists.infradead.org, linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org, nouveau@lists.freedesktop.org, pabeni@redhat.com, paul.burton@mips.com, pmladek@suse.com, robh@
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-11-30 at 13:54 -0800, Jarkko Sakkinen wrote:
> On Fri, Nov 30, 2018 at 01:48:08PM -0800, David Miller wrote:
> > From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Date: Fri, 30 Nov 2018 13:44:05 -0800
> > 
> > > On Fri, Nov 30, 2018 at 01:01:02PM -0800, James Bottomley wrote:
> > > > No because use of what some people consider to be bad language
> > > > isn't
> > > > necessarily abusive, offensive or degrading.  Our most heavily
> > > > censored
> > > > medium is TV and "fuck" is now considered acceptable in certain
> > > > contexts on most channels in the UK and EU.
> > > 
> > > This makes following the CoC extremely hard to a non-native
> > > speaker as
> > > it is not too explicit on what is OK and what is not. I did
> > > through the
> > > whole thing with an eye glass and this what I deduced from it.
> > 
> > It would be helpful if you could explain what part of the language
> > is unclear wrt. explaining how CoC does not apply to existing code.
> > 
> > That part seems very explicit to me.
> 
> Well, now that I re-read it, it was this part to be exact:
> 
> "Maintainers have the right and responsibility to remove, edit, or
> reject comments, commits, code, wiki edits, issues, and other
> contributions that are not aligned to this Code of Conduct, or to ban
> temporarily or permanently any contributor for other behaviors that
> they deem inappropriate, threatening, offensive, or harmful."
> 
> How this should be interpreted?

Firstly, this is *only* about contributions going forward.  The
interpretation document says we don't have to look back into the
repository and we definitely can't remove something from git that's
already been committed.

As a Maintainer, if you feel bad language is inappropriate for your
subsystem then you say so and reject with that reason patches that come
in containing it (suggesting alternative rewordings).  However, your
determination about what is or isn't acceptable in your subsystem isn't
binding on other maintainers, who may have different standards ... this
is identical to what we do with coding, like your insistence on one
line per variable or other subsystem's insistence on reverse christmas
tree for includes ...

James


> I have not really followed the previous CoC discussions as I try to
> always use polite language so I'm sorry if this duplicate.
> 
> /Jarkko
> 
