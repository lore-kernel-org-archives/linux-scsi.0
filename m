From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Wed, 28 May 2014 08:51:05 -0700
Message-ID: <20140528155105.GA14246@infradead.org>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
 <536AB13E.6080906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaE1PvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 11:51:12 -0400
Content-Disposition: inline
In-Reply-To: <536AB13E.6080906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jay Kallickal <jayamohank@gmail.com>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On Wed, May 07, 2014 at 05:18:38PM -0500, Mike Christie wrote:
> It looks like if that race is possible then we could also free the ep
> while you are accessing right? I think you would need to get a ref to
> the ep.
> 
> What command/function tells the card to stop sending the driver
> events/notifications/ios for that connection? Is it beiscsi_close_conn
> or mgmt_invalidate_connection?

Jay,

can you look into this issue please?  I've applied the series to the
scsi queue for now, but I'd really prefer to see this addressed ASAP.

