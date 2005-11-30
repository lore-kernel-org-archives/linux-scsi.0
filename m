From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Wed, 30 Nov 2005 19:17:32 +0000
Message-ID: <20051130191732.GC19164@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57535 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751505AbVK3TRf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:17:35 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B76@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 04:16:33PM -0500, James.Smart@Emulex.Com wrote:
> Well - we would prefer the vendor test the system as it should behave
> in normal circumstances rather than test-suite-derived conditions.
> 
> Yes, we will sign up for this. However, we have several items on our
> plate so we won't be on this quickly. I would hope there would be no
> issue with accepting the patch as is and backing out the relatived code
> as part of the eventual patch.

No.  As you might have noticed fixing mid-layer bugs in drivers is generally
not okay.

