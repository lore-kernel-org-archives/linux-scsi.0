From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK constants
Date: Mon, 7 Mar 2005 12:37:39 +0000
Message-ID: <20050307123739.GC28741@parcelfarce.linux.theplanet.co.uk>
References: <20050306222721.1E3391F208@trashy.coderock.org> <yq0ekerepaf.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63686 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261450AbVCGMhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 07:37:42 -0500
Content-Disposition: inline
In-Reply-To: <yq0ekerepaf.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: domen@coderock.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

On Mon, Mar 07, 2005 at 05:14:16AM -0500, Jes Sorensen wrote:
> >>>>> "domen" == domen  <domen@coderock.org> writes:
> 
> domen> Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h when
> domen> calling pci_set_dma_mask() or pci_set_consistent_dma_mask() See
> domen> http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for
> domen> details
> 
> Why?
> 
> It's ugly and really serves no purpose except for obfuscation.

We've had drivers with typos.  Missing one f suddenly causes all your
memory to come from ZONE_DMA.  Having an extra f causes your driver to
work ... most of the time on machines with >4GB ram.  Sure, your driver
doesn't, but when looking over a lot of drivers, it's easier if everyone's
using the same macros.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
