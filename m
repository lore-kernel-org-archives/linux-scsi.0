From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym2: remove dead SYM_OPT_HANDLE_IO_TIMEOUT code
Date: Wed, 3 Nov 2004 04:36:06 +0000
Message-ID: <20041103043606.GS24690@parcelfarce.linux.theplanet.co.uk>
References: <20041102110536.GA28902@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9600 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261430AbUKCEgH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 23:36:07 -0500
Content-Disposition: inline
In-Reply-To: <20041102110536.GA28902@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 12:05:36PM +0100, Christoph Hellwig wrote:
> this was used only by ancient BSDs that didn't have timeout handling
> in the midlayer.

Thanks.  Applied a superset of this patch (also deleted
SYM_CONF_TIMEOUT_ORDER_MAX).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
