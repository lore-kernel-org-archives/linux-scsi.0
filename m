From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [3/21] Remove unchecked_isa_dma in advansys.c
Date: Thu, 6 Mar 2008 23:04:32 +0100
Message-ID: <20080306220432.GA31833@one.firstfloor.org>
References: <20080306951.147874949@firstfloor.org> <20080306205122.87EF81B419C@basil.firstfloor.org> <20080306210458.GZ24386@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:45810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYCFWDE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:03:04 -0500
Content-Disposition: inline
In-Reply-To: <20080306210458.GZ24386@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Thu, Mar 06, 2008 at 02:04:59PM -0700, Matthew Wilcox wrote:
> On Thu, Mar 06, 2008 at 09:51:21PM +0100, Andi Kleen wrote:
> > That patch is a little more complicated than the others. advansys
> > was the only ISA driver who actually passed ->cmnd to the firmware.
> 
> Why did you ignore me the first time when I told you that you'd made a
> mistake?

Can you be more specific what you complained about? 

As I remember you had a quite vague high level complaint last time
("very ugly patch") but you didn't go into details as what exactly you 
considered ugly. I assumed you meant not using the DMA API but
raw get_free_pages with "ugly", and I fixed that.

If you have any other issues with the patch please describe them clearly.
Assume I'm like a 4 year old regarding SCSI arcana.

-Andi

