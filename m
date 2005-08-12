From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 20:14:00 +0100
Message-ID: <20050812191400.GB18979@parcelfarce.linux.theplanet.co.uk>
References: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com> <1123873551.5546.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5309 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S1751244AbVHLTLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 15:11:21 -0400
Content-Disposition: inline
In-Reply-To: <1123873551.5546.116.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Aug 12, 2005 at 03:05:51PM -0400, Ming Zhang wrote:
> i tried to remove the SA_SHIRQ option when request_irq(), unfortunately
> it seems that the IO-APIC will only try to allocate same # to it and
> once that slot is used, the request_irq will fail.

Yes.  These two interrupts are physically on the same wire attached to
the IO-APIC.  You need to put the card in a different slot to change
which interrupt it gets.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
