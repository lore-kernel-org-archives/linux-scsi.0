From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi_debug: support scsi-mq, queues and locks
Date: Thu, 10 Jul 2014 04:02:40 -0700
Message-ID: <20140710110240.GA4994@infradead.org>
References: <53BAA104.6090207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGJLCk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 07:02:40 -0400
Content-Disposition: inline
In-Reply-To: <53BAA104.6090207@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch looks reasonable to me.  I'd prefer if we didn't have to keep
the optional host_lock mode for the long run, but if it's important to
you for now we can keep it for a while.

And chance you could split updates into a series of updates for future
changes?

Reviewed-by: Christoph Hellwig <hch@lst.de>
