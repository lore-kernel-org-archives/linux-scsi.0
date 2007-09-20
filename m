From: stefan@mdy.univie.ac.at (Stefan Boresch)
Subject: Re: aic79xx problems
Date: Thu, 20 Sep 2007 16:34:48 +0200
Message-ID: <20070920143448.GF1606@loop.mdy.univie.ac.at>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at> <1190297751.3360.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from epsilon.mdy.univie.ac.at ([131.130.40.18]:44459 "EHLO
	epsilon.mdy.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXITOev (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 10:34:51 -0400
Received: from loop.mdy.univie.ac.at (loop.mdy.univie.ac.at [131.130.40.12])
	by server1.mdy.univie.ac.at (Postfix) with ESMTP id 41F0C16C2B4
	for <linux-scsi@vger.kernel.org>; Thu, 20 Sep 2007 16:30:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1190297751.3360.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Thank you for both your replies.

On Thu, Sep 20, 2007 at 09:15:51AM -0500, James Bottomley wrote:
> On Thu, 2007-09-20 at 15:04 +0200, Stefan Boresch wrote:
> > I could live with all this if kernels 2.6.2x I have tried would not
> > simply crash.  When the aic79xx module loads, I get again endless
> > 
> > >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> > 
> > listings, but the warnings / error messages get more and more severe
> > until the system hangs.
> 
> 
> This shouldn't be happening; we should get the same behaviour as the old
> kernels (lots of scary warnings and problems but then turn off wide and
> continue on).  Investigating this, unfortunately, is going to be a real
> pain.  However, I think I can cut a cable to simulate your problem.
> 
> 

I guess I'll "attack" the hardware angle by harassing the vendor (who
so far was completely "sure" that it "must" be a driver issue). My
problem is that this SCSI only system is really a "stray dog" in my
zoo, so I have no replacement cables / parts whatsoever, i.e., it will
take a while for them to get these to me.

So, since I seem to have a slightly broken machine at hand, let me
know whether I can try/test anything to fix the issues the newer
kernels might have.

In any case, already many thanks for your quick reply!

Stefan

-- 
Stefan Boresch
Institute for Computational Biological Chemistry
University of Vienna, Waehringerstr. 17       A-1090 Vienna, Austria
Phone: -43-1-427752715                        Fax:   -43-1-427752790
