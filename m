From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit conversions
Date: Thu, 28 Oct 2004 08:43:25 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028104325.GA5741@logos.cnet>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net> <Pine.LNX.4.58L.0410220054010.15504@blysk.ds.pg.gda.pl> <20041022183057.GA23032@beardog.cca.cpqcorp.net> <Pine.LNX.4.58L.0410222157080.22781@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:60630 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263058AbUJ1NYV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 09:24:21 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58L.0410222157080.22781@blysk.ds.pg.gda.pl>
List-Id: linux-scsi@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: mikem <mikem@beardog.cca.cpqcorp.net>, axboe@suse.de, linux-scsi@vger.kernel.org

On Fri, Oct 22, 2004 at 09:59:52PM +0100, Maciej W. Rozycki wrote:
> On Fri, 22 Oct 2004, mikem wrote:
> 
> > >  These constructs (casts as lvalues) are deprecated with GCC 3.4 (a
> > > warning is triggered) and no longer supported with 4.0.  Please consider
> > > rewriting -- you'll probably need an auxiliary variable.
> [...]
> > Is this documented somewhere?
> 
>  Sure:
> 
> http://gcc.gnu.org/gcc-3.4/changes.html
> 
> http://gcc.gnu.org/gcc-4.0/changes.html
> 
> Plus reported zillion of times here and elsewhere. 

Mike, 

Can you fix the warning and resend please?
