From: stefan@mdy.univie.ac.at (Stefan Boresch)
Subject: Re: aic79xx problems
Date: Thu, 20 Sep 2007 16:53:36 +0200
Message-ID: <20070920145336.GH1606@loop.mdy.univie.ac.at>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at> <1190297751.3360.15.camel@localhost.localdomain> <20070920143448.GF1606@loop.mdy.univie.ac.at> <1190299275.3360.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from helix.mdy.univie.ac.at ([131.130.40.7]:60507 "EHLO
	epsilon.mdy.univie.ac.at" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755113AbXITOxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 10:53:39 -0400
Content-Disposition: inline
In-Reply-To: <1190299275.3360.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Boresch <stefan@mdy.univie.ac.at>, linux-scsi@vger.kernel.org


On Thu, Sep 20, 2007 at 09:41:14AM -0500, James Bottomley wrote:
> On Thu, 2007-09-20 at 16:34 +0200, Stefan Boresch wrote:
> > So, since I seem to have a slightly broken machine at hand, let me
> > know whether I can try/test anything to fix the issues the newer
> > kernels might have.
> 
> It will take me a while to set up the configuration, so the dmesg from
> the failing 2.6.2x might be helpful, just in case it's an obvious
> problem that doesn't need debugging (small chance, but still possible).
> 

I will try, but a very dumb question first. If I have a kernel that
crashes because of a disk problem ..., how do I get to save the output?
(Never worked with a serial console, but there might be a first time
for everything ...) But maybe there is an obvious solution that I overlook?

Or should I just try to watch and look for certain messages (ordering of
messages), which given the huge amount of output seems a bit daunting ...

Best regards,

Stefan

-- 
Stefan Boresch
Institute for Computational Biological Chemistry
University of Vienna, Waehringerstr. 17       A-1090 Vienna, Austria
Phone: -43-1-427752715                        Fax:   -43-1-427752790
