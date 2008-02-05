From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 5 Feb 2008 12:39:14 -0800 (PST)
Message-ID: <4432.74783.qm@web31814.mail.mud.yahoo.com>
References: <1202243385.3133.82.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:46829 "HELO
	web31814.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760155AbYBEUjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 15:39:19 -0500
In-Reply-To: <1202243385.3133.82.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>

--- On Tue, 2/5/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > Wrong ... we don't export non-SCSI devices as
> SCSI
> > > (with the single and
> > > rather annoying exception of ATA via SAT).
> > 
> > I didn't say you should do that.  I had already
> > mentioned that vendors export such controls
> > as either enclosure or processor type devices,
> > and this is why I told you that that is what
> > needs to be exported, which incidentally is
> > a device node of that type.
> > 
> > Without a common usage model already in the kernel
> > to abstract (e.g. sd for block device, since you
> brought
> > that up) your abstraction seems redundant and
> arbitrary.
> 
> Exactly, so the first patch in this series (a while ago
^^^^^^^^^^^

See last paragraph.

> now) was a
> common usage model abstraction of enclosures, and the
> second was an
> implementation in terms of SES.   I will do one in terms of
> SGPIO as
> well ... assuming I ever find a SGPIO enclosure ...

The vendor would've abstracted that away most commonly
using SES.

> 
> > Your kernel code already uses READ DIAGNOSTIC, etc,
> > and I'd rather leave that to user-space.
> 
> You can do it in user space as well.  It's just a bit
> difficult to get
> information out of a SES enclosure without using it, and
> getting some of
> the information is a requirement of the abstraction.

You missed my point.  Your abstraction is redundant and
arbitrary -- it is not based on any known, in-practice,
usage model, already in place that needs a better, common
way of doing XYZ, and therefore needs an abstraction.

   Luben

