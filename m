From: Christoph Hellwig <hch@infradead.org>
Subject: Re: can_queue modification within select_queue_depths
Date: Thu, 19 Aug 2004 12:19:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819121902.A8273@infradead.org>
References: <41233AB1.7030605@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:18695 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265492AbUHSLTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 07:19:04 -0400
Content-Disposition: inline
In-Reply-To: <41233AB1.7030605@il.marvell.com>; from Saeed.Bishara@il.marvell.com on Wed, Aug 18, 2004 at 02:17:05PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2004 at 02:17:05PM +0300, Saeed Bishara wrote:
> Hi,
>     is it allowed to modify the host can_queue with select_queue_depths 
> function?

Yes.

>     if yes, is it needed to lock/unlock io_request_lock ?
> thanks  

Dunno about 2.4 locking, but given this is at init time and thus implicitly
serialized I wouldn't care too much about locking.


BTW, if you happen to work on a driver for the marvell SATA part please
talk to Jeff Garzik who is doing a libata driver for it.  Also note that
we're not going to accept pure SCSI LLDDs for (S)ATA hardware.

