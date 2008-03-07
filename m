From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [3/21] Remove unchecked_isa_dma in advansys.c
Date: Thu, 6 Mar 2008 17:59:17 -0700
Message-ID: <20080307005917.GA24386@parisc-linux.org>
References: <20080306951.147874949@firstfloor.org> <20080306205122.87EF81B419C@basil.firstfloor.org> <20080306210458.GZ24386@parisc-linux.org> <20080306220432.GA31833@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52861 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYCGA7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 19:59:34 -0500
Content-Disposition: inline
In-Reply-To: <20080306220432.GA31833@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Thu, Mar 06, 2008 at 11:04:32PM +0100, Andi Kleen wrote:
> On Thu, Mar 06, 2008 at 02:04:59PM -0700, Matthew Wilcox wrote:
> > On Thu, Mar 06, 2008 at 09:51:21PM +0100, Andi Kleen wrote:
> > > That patch is a little more complicated than the others. advansys
> > > was the only ISA driver who actually passed ->cmnd to the firmware.
> > 
> > Why did you ignore me the first time when I told you that you'd made a
> > mistake?
> 
> Can you be more specific what you complained about? 

I was very specific.

http://marc.info/?l=linux-scsi&m=120403423513244&w=2

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
