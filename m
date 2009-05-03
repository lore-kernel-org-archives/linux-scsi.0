From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 3 May 2009 09:24:08 -0600
Message-ID: <20090503152408.GT8822@parisc-linux.org>
References: <49FDA2CA.4040601@tremplin-utc.net> <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com> <20090503151153.GS8822@parisc-linux.org> <1241364068.5596.55.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33369 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZECPYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:24:08 -0400
Content-Disposition: inline
In-Reply-To: <1241364068.5596.55.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Sun, May 03, 2009 at 10:21:08AM -0500, James Bottomley wrote:
> On Sun, 2009-05-03 at 09:11 -0600, Matthew Wilcox wrote:
> > On Sun, May 03, 2009 at 09:57:15AM -0500, James Bottomley wrote:
> > > Actually, I'd really rather not alter the default value of this setting.
> > > Multi-lun is rapidly becoming obsolete: any modern devices conforming to
> > > SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us out
> > > of the issue.  Conversely, the ancient devices which rely on correctly
> > > setting this are more likely to get upset about any change in the
> > > balance.
> > 
> > Yes, but USB devices are prohibited from being SCSI-3 devices, so it's
> > not becoming obsolete.
> 
> No they're not, there's nothing in the USB specs that say this.  UAS
> will specifically require it.

I didn't mean "prohibited by the USB spec", I meant "prohibited by Linux",
for the exact reason you say below.

> The problem is we don't trust USB manufacturers with standards
> compliance any further than they could spit a rat, so we assume when
> they say they conform to SCSI-3 or above that they must have got it
> wrong and push it back down to SCSI-2.
> 
> Because of this, no-one actually knows how many working SCSI-3 USB
> devices we might have supported.

This is true.  Suggestions for a better way to handle USB devices ... ?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
