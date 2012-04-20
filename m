From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 18:58:23 -0400
Message-ID: <20120420225822.GA10769@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
 <20120405144721.GA18437@redhat.com>
 <20120420144538.GB8155@redhat.com>
 <20120420173405.GA8846@redhat.com>
 <20120420214120.159e2690@pyramind.ukuu.org.uk>
 <20120420215825.GA10406@redhat.com>
 <20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 20 2012 at  6:20pm -0400,
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > The kernel is GPL, all derived works of a GPL codebase are required to be
> > > GPL. There is no magic rule about modules. I've stated that repeatedly
> > > for anything containing a line of code I own. GregKH has made it very
> > > clear for his code, and so it goes on.
> > 
> > This isn't about adding Linux functionality to a proprietary driver.
> 
> Let me quote back your previous message
> 
> 	"Allow a proprietary non-GPL multipath driver, like EMC
> 	PowerPath, to detach a scsi_dh using scsi_dh_detach."
> 
> what part of that isn't about proprietary drivers.

Sure Alan, seize on "proprietary" and "EXPORT_SYMBOL_GPL".. and gloss
right over the fact that what is being proposed is reasonable.

Any multipath driver should be able to detach a scsi_dh module.  As is
evidenced by the fact that they can already make use of sysfs to do so.

Relaxing the scsi_dh_detach interface makes it easier for a long
standing proprietary driver to get out of Linux's way.

But yeah, I'm sure you'll gloss over that too.
 
> > If Linux is masking SCSI sense that Powerpath needs to see in order to
> > function then they need a way to shut off that conflicting functionality
> > in Linux.  What they have enjoyed until now is that Linux has treated
> > them with kid gloves -- by not always attaching scsi_dh to each SCSI
> > device during SCSI device scan.
> 
> They can submit the powerpath code to the GPL kernel and it can get dealt
> with nicely.
> 
> > > I'm dying to see anyone make the moral argument for it too.
> > 
> > I think you're blinded by some innate violent pain reaction to seeing
> > s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/
> 
> No. I'm just reminding you and Red Hat that the kernel is subject to the
> GPLv2 licence and that adding/removing _GPL from a symbol doesn't
> magically allow you to use proprietary modules as you claim.
> 
> > As I said in the header, Linux's ability to properly support scanning
> > LUNs with multiple paths has been fragile for _years_ purely because we
> > never had the balls to always attach the scsi_dh which enables Linux to
> > work well.  We didn't because of fear that we'd break PowerPath.
> 
> Thats unfortunate. You mean your company has been intentionally
> leaving the Linux kernel poorer for the sake of dubious proprietary
> code ?
> 
> You might want to stop digging, or at least use a spade not an excavator.

_Upstream_ has kept it that way because we've been concerned about
breaking PowerPath in enterprises where Linux is deployed.  Upstream has
been good citizens to the fault of Linux.

Please stop being a drama queen and stop putting words in my mouth.

> > As a result, Linux has suffered (in the form of reduced functionality).
> > Now your arguing that the because scsi_dh_detach() will become
> > EXPORT_SYMBOL it somehow makes PowerPath a derived work if they were to
> 
> I suspect it is already a derived work, but right now that's their
> problem. You are making it yours as well.
> 
> > The two other people (scsi_dh maintainers) that Acked-by this change
> > work for companies other than EMC.  James is the SCSI maintainer and
> > understands what is going on here.  Like me, they are domain experts.
> > 
> > What are you?
> 
> I'm a rights holder. Domain expertise isn't relevant here. The code I
> provided is licensed under the GPL. Whether the symbol is EXPORT_SYMBOL
> or EXPORT_SYMBOL_GPL any derivative code (eg code that requires the
> kernel be modified to match it) cannot call it.

Remind me again when you ever developed anything to do with scsi_dh?

To be clear: PowerPath doesn't _need_ this.  Not even close.

Linux is improved by not having to walk on egg shells that attaching a
helpful linux-only layer in kernel will somehow screw up some 3rd party
software that a customer values.

You still don't get it... yet you'll saber rattle behind generic GPL
lawyer-up nonsense.

It is sad that you didn't even read the important technical aspects of
my previous reply that prove you're being a troll.

I implore you to defer to the domain experts and refrain from continued
late Friday night geek melo-drama.
