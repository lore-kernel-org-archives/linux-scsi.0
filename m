From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 23:20:43 +0100
Message-ID: <20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
References: <20111215214440.GA17677@redhat.com>
	<4EF039D5.5010201@suse.de>
	<20120405144721.GA18437@redhat.com>
	<20120420144538.GB8155@redhat.com>
	<20120420173405.GA8846@redhat.com>
	<20120420214120.159e2690@pyramind.ukuu.org.uk>
	<20120420215825.GA10406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51817 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2DTWSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 18:18:14 -0400
In-Reply-To: <20120420215825.GA10406@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org

> > The kernel is GPL, all derived works of a GPL codebase are required to be
> > GPL. There is no magic rule about modules. I've stated that repeatedly
> > for anything containing a line of code I own. GregKH has made it very
> > clear for his code, and so it goes on.
> 
> This isn't about adding Linux functionality to a proprietary driver.

Let me quote back your previous message

	"Allow a proprietary non-GPL multipath driver, like EMC
	PowerPath, to detach a scsi_dh using scsi_dh_detach."

what part of that isn't about proprietary drivers.

> If Linux is masking SCSI sense that Powerpath needs to see in order to
> function then they need a way to shut off that conflicting functionality
> in Linux.  What they have enjoyed until now is that Linux has treated
> them with kid gloves -- by not always attaching scsi_dh to each SCSI
> device during SCSI device scan.

They can submit the powerpath code to the GPL kernel and it can get dealt
with nicely.

> > I'm dying to see anyone make the moral argument for it too.
> 
> I think you're blinded by some innate violent pain reaction to seeing
> s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/

No. I'm just reminding you and Red Hat that the kernel is subject to the
GPLv2 licence and that adding/removing _GPL from a symbol doesn't
magically allow you to use proprietary modules as you claim.

> As I said in the header, Linux's ability to properly support scanning
> LUNs with multiple paths has been fragile for _years_ purely because we
> never had the balls to always attach the scsi_dh which enables Linux to
> work well.  We didn't because of fear that we'd break PowerPath.

Thats unfortunate. You mean your company has been intentionally
leaving the Linux kernel poorer for the sake of dubious proprietary
code ?

You might want to stop digging, or at least use a spade not an excavator.

> As a result, Linux has suffered (in the form of reduced functionality).
> Now your arguing that the because scsi_dh_detach() will become
> EXPORT_SYMBOL it somehow makes PowerPath a derived work if they were to

I suspect it is already a derived work, but right now that's their
problem. You are making it yours as well.

> The two other people (scsi_dh maintainers) that Acked-by this change
> work for companies other than EMC.  James is the SCSI maintainer and
> understands what is going on here.  Like me, they are domain experts.
> 
> What are you?

I'm a rights holder. Domain expertise isn't relevant here. The code I
provided is licensed under the GPL. Whether the symbol is EXPORT_SYMBOL
or EXPORT_SYMBOL_GPL any derivative code (eg code that requires the
kernel be modified to match it) cannot call it.

I'm recommended by my lawyer to always remind people of this when such a
claim is made. It ensures that triple damages for wilful infringement
will apply unless the other party can show it reviewed the situation
carefully and its appropriately qualified legal staff reached a different
conclusion.

Obviously what action you take is up to Red Hat's legal (and PR) folks.
However I'd suggest you talk to them first, as per Red Hat training
unless that has changed..

Alan
