From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK constants
Date: 07 Mar 2005 09:27:17 -0500
Message-ID: <yq04qfnedkq.fsf@jaguar.mkp.net>
References: <20050306222721.1E3391F208@trashy.coderock.org>
	<yq0ekerepaf.fsf@jaguar.mkp.net>
	<20050307123739.GC28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from [192.139.46.150] ([192.139.46.150]:43706 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S261181AbVCGO1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 09:27:38 -0500
In-Reply-To: <20050307123739.GC28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: domen@coderock.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> On Mon, Mar 07, 2005 at 05:14:16AM -0500, Jes Sorensen wrote:
>> >>>>> "domen" == domen <domen@coderock.org> writes:
>> 
domen> Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h when
domen> calling pci_set_dma_mask() or pci_set_consistent_dma_mask() See
domen> http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for
domen> details
>> It's ugly and really serves no purpose except for obfuscation.

Matthew> We've had drivers with typos.  Missing one f suddenly causes
Matthew> all your memory to come from ZONE_DMA.  Having an extra f
Matthew> causes your driver to work ... most of the time on machines
Matthew> with >4GB ram.  Sure, your driver doesn't, but when looking
Matthew> over a lot of drivers, it's easier if everyone's using the
Matthew> same macros.

If these were the only two masks ever used I'd agree with you. However
there's several other in use and more will probably be added, so we're
going to end up with drivers sometimes using constants and other times
hex values causing an even bigger mess ;-(

Cheers,
Jes
