From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 09:03:01 -0600
Message-ID: <1197903781.3204.4.camel@localhost.localdomain>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com>
	 <20071217143641.760d4162@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:54249
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbXLQPDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 10:03:09 -0500
In-Reply-To: <20071217143641.760d4162@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Filippos Papadopoulos <psybases@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Mon, 2007-12-17 at 14:36 +0000, Alan Cox wrote:
> On Mon, 17 Dec 2007 16:40:53 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > On Mon, Dec 17 2007 at 15:05 +0200, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > >> initio doesn't seem to have a maintainer...
> > >>
> > >> Are you able to identify any earlier kernel which worked OK?
> > >>
> > >> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> > >> for that device we can take a look.
> > > 
> > > If I remember rightly the fixes for this went into the scsi tree a couple
> > > of months ago. The patch is in the -mm tree as well. No idea why its
> > > gotten stuck as an obvious one liner.
> > > 
> > > Alan
> > > -
> > You mean this one:
> > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=ba2c270154cc90c9a8bfc45b7bed4cca78c75aaf
> > 
> > It's only queued for 2.6.25 via scsi-misc.
> > 
> > I have found another bug. (See other mail in thread). I Will wait for testing
> > and submit a proper patch.
> 
> That one yes - which really should have gone straight into the main tree
> as the initio driver has been broken all the time it sits queued for
> future patches. It can't make the problem any worse - the driver does not
> work.

Well, the change log isn't very committal for "rush me immediately into
main line" plus, as far as I could dig out, there was no confirmation
that it actually worked.  This way, I can now say please try the current
-mm kernel to the bug reporter and we get to see if this fixes the
problem.

James


