From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 08:06:34 -0700
Message-ID: <20090228150633.GQ16891@parisc-linux.org>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net> <1235663301.19035.44.camel@localhost.localdomain> <yq1prh5ey7b.fsf@sermon.lab.mkp.net> <49A94FEB.6050400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50348 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZB1PGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 10:06:52 -0500
Content-Disposition: inline
In-Reply-To: <49A94FEB.6050400@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Sat, Feb 28, 2009 at 03:53:31PM +0100, Stefan Richter wrote:
> Martin K. Petersen wrote:
> > The thing is we need to start sending RC16 to a lot of drives very soon
> > because of the 4KB thing.  And as we've seen RC16 breaks a lot of junk
> > devices.  So we need a good indicator other than the SCSI rev. because
> > that unfortunately doesn't cut it.
> 
> /Is/ the used transport protocol a good indicator for whether a
> particular target breaks by READ CAPACITY 16?  I have doubts.  Command
> set support is independent of transport protocol support.

You must admit there's a striking correlation between USB devices and
completely failing to follow the SCSI spec.  Our current workaround of
clamping USB devices at a SCSI_2 level does avoid much of the pain.

I can only hope that UAS devices actually implement SCSI instead of
flicking bits at random until vista doesn't crash every time you plug
it in.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
