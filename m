From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] remove scsi_set_device
Date: Sat, 11 Jun 2005 19:51:19 +0100
Message-ID: <20050611185119.GA3406@pentafluge.infradead.org>
References: <20050610230501.GA9581@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38020 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261775AbVFKSvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:51:21 -0400
Content-Disposition: inline
In-Reply-To: <20050610230501.GA9581@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 01:05:01AM +0200, Christoph Hellwig wrote:
> scsi_add_host is the proper place to set the device, but people copy
> the scsi_set_device usage from older drivers again and again.
> 
> note that this leaves some legacy drivers like qlogicisp/qlogicfc
> without pci association in sysfs, but they're scheduled to go away soon
> anyway.

Always separate out libata changes and send them to me (or at
least CC).

There are tons of libata patches queued, and they need to go into
that queue.

Further, I need to update 2.4.x for changes still.

	Jeff



