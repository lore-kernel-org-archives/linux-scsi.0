From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Tue, 30 Sep 2008 11:45:05 -0600
Message-ID: <20080930174505.GC13822@parisc-linux.org>
References: <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be> <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com> <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be> <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com> <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com> <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be> <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com> <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be> <806dafc20809301032n559832et45f3bf5e3f7c495c@mail.gmail.com> <20080930174151.GB13822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49499 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYI3RpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 13:45:07 -0400
Content-Disposition: inline
In-Reply-To: <20080930174151.GB13822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Monty Montgomery <monty@xiph.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Tue, Sep 30, 2008 at 11:41:51AM -0600, Matthew Wilcox wrote:
> On Tue, Sep 30, 2008 at 01:32:15PM -0400, Monty Montgomery wrote:
> > On Tue, Sep 30, 2008 at 11:21 AM, Geert Uytterhoeven
> > <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > >> (May I ask-- why the hard starting/stopping of the interface?  Power saving?]
> > why the calls to sg_start?
> 
> In this case, sg means scatter/gather, and it's a purely internal
> interface.  It does not start/stop the drive, nor the scsi interface.

That'll teach me to comment before reading the entire thread.  Please
ignore this mistaken explanation; I thought you were commenting on a
patch, not on the commands used at the command line.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
