From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/1] drivers/scsi/lasi700.c: Use the DMA_32BIT_MASK constant
Date: Sat, 19 Mar 2005 21:03:58 +0000
Message-ID: <20050319210358.GN21986@parcelfarce.linux.theplanet.co.uk>
References: <20050319131932.9CBD01ECA8@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37034 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261790AbVCSVEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 16:04:02 -0500
Content-Disposition: inline
In-Reply-To: <20050319131932.9CBD01ECA8@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

On Sat, Mar 19, 2005 at 02:19:32PM +0100, domen@coderock.org wrote:
> Use the DMA_32BIT_MASK constants from dma-mapping.h
> when calling dma_set_mask().

Already submitted.  I told you I'd take it through the parisc tree.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
