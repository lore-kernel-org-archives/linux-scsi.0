From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11]  lpfc 8.1.1 : Added code to adjust lun queue depth to avoid target overloading
Date: Mon, 28 Nov 2005 17:38:49 +0000
Message-ID: <20051128173849.GA22955@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4E@xbl3.emulex.com> <1133199363.2824.55.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59596 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751262AbVK1Riu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 12:38:50 -0500
Content-Disposition: inline
In-Reply-To: <1133199363.2824.55.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 06:36:03PM +0100, Arjan van de Ven wrote:
> On Mon, 2005-11-28 at 11:42 -0500, James.Smart@Emulex.Com wrote:
> > Added code to adjust lun queue depth to avoid target overloading.
> > 
> 
> eh isn't this a midlayer task? eg on queue full... auto shrink the
> queue ? why would a driver need to bother with this?

Yes, it is.  we even have some midlayer queue tracking code that
Doug Ledford wrote early in the 2.5.x series.  Unfortunately only
the aic7xxx_old driver is using it so far.

