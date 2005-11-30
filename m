From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/11]  lpfc 8.1.1: Miscellaneous Cleanups
Date: Wed, 30 Nov 2005 19:15:14 +0000
Message-ID: <20051130191514.GA19164@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B77@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17346 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751538AbVK3TPP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:15:15 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B77@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 04:52:38PM -0500, James.Smart@Emulex.Com wrote:
> > Once you start touching these could we please get rid of the 
> > bitfield for
> > hardware registers abuse?  These should be proper 8/16/32 bit 
> > members and
> > then using bitmask as in all proper written drivers.
> 
> Agreed. A coding style that I've preached as well. But with 
> existing code, it takes a while to adapt.

Sure.  Just a notice while I saw this in a diff context.

> We'll add this to our todo list. Given the volume of the change,
> don't look for this to be resolved too quickly. 

Ok.

