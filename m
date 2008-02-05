From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 05 Feb 2008 14:29:45 -0600
Message-ID: <1202243385.3133.82.camel@localhost.localdomain>
References: <471033.35291.qm@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52841 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbYBEU3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 15:29:49 -0500
In-Reply-To: <471033.35291.qm@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>

On Tue, 2008-02-05 at 11:33 -0800, Luben Tuikov wrote:
> > Wrong ... we don't export non-SCSI devices as SCSI
> > (with the single and
> > rather annoying exception of ATA via SAT).
> 
> I didn't say you should do that.  I had already
> mentioned that vendors export such controls
> as either enclosure or processor type devices,
> and this is why I told you that that is what
> needs to be exported, which incidentally is
> a device node of that type.
> 
> Without a common usage model already in the kernel
> to abstract (e.g. sd for block device, since you brought
> that up) your abstraction seems redundant and arbitrary.

Exactly, so the first patch in this series (a while ago now) was a
common usage model abstraction of enclosures, and the second was an
implementation in terms of SES.   I will do one in terms of SGPIO as
well ... assuming I ever find a SGPIO enclosure ...

> Your kernel code already uses READ DIAGNOSTIC, etc,
> and I'd rather leave that to user-space.

You can do it in user space as well.  It's just a bit difficult to get
information out of a SES enclosure without using it, and getting some of
the information is a requirement of the abstraction.

James


