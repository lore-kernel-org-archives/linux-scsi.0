From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/7] gdth: split out pci probing
Date: Sat, 21 Jul 2007 16:16:34 -0400
Message-ID: <46A269A2.5070301@garzik.org>
References: <20070721170151.GD4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760626AbXGUUQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:16:37 -0400
In-Reply-To: <20070721170151.GD4150@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: leubner@adaptec.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Split out per-device pci probing and put it under proper CONFIG_PCI.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

ACK patches 1-3

My approach went for bug-for-bug compatibility, with the cleanups and 
fixes later.  Your approach improves error handling and formatting at 
the same time.  Same end result and goal, really.

	Jeff


