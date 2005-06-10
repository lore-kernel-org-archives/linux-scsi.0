From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks with kernel defines)
Date: Fri, 10 Jun 2005 22:30:03 +0100
Message-ID: <20050610213003.GI24611@parcelfarce.linux.theplanet.co.uk>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net> <42A9C60E.3080604@pobox.com> <1118436000.6423.42.camel@mindpipe> <1118436306.5272.37.camel@laptopd505.fenrus.org> <1118438253.6423.72.camel@mindpipe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63413 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261250AbVFJV3N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 17:29:13 -0400
Content-Disposition: inline
In-Reply-To: <1118438253.6423.72.camel@mindpipe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 10, 2005 at 05:17:32PM -0400, Lee Revell wrote:
> OK, this covers the drivers I know.  I didn't make any attempt to check
> them all.

I know of two others ...

sym2 has:
#define DMA_DAC_MASK    0x000000ffffffffffULL /* 40-bit */

and aic7xxx has:
        const uint64_t   mask_39bit = 0x7FFFFFFFFFULL;

Would you mind respinning your patch to include these?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
