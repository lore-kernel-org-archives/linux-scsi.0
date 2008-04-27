From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] aic7xxx: teach aicasm to not emit unused debug
	code/data
Date: Sun, 27 Apr 2008 08:48:37 -0500
Message-ID: <1209304117.3801.4.camel@localhost.localdomain>
References: <200804250432.16943.vda.linux@googlemail.com>
	 <200804250434.49377.vda.linux@googlemail.com>
	 <200804250436.01295.vda.linux@googlemail.com>
	 <200804250441.43480.vda.linux@googlemail.com>  <4811D635.4020904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37056 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520AbYD0Nsl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 09:48:41 -0400
In-Reply-To: <4811D635.4020904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, 2008-04-25 at 15:01 +0200, Hannes Reinecke wrote:
> Hi Denys,
> 
> Denys Vlasenko wrote:
> > Add "dont_generate_debug_code" syntax handling to aicasm_gram.y
> > 
> > aic79xx.reg, aic7xxx.reg: add dont_generate_debug_code keyword
> > for registers which are never referenced by the driver.
> > 
> > aicasm.c, aicasm_symbol.[ch]: don't emit code for those regs;
> > also add "const" keyword to generated code in few places.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> No.
> Adding a symbol to each and every register definition
> which has to be hand-crafted anyway is not the correct way.
> 
> I would prefer this: Add a 'count' variable to each symbol
> which gets increased every time the symbol is referenced.
> And then modify the register definition to include counts
> for symbols which are referenced from the source code only
> and not from the sequencer code.
> 
> This will give us an automatic usage count for the symbols
> with only minimal hand-crafting.
> 
> James, please apply.

Well .. I have done, but you can take a black mark for this ... there's
no Signed-off-by line.

James


