From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fcoe: Reduce max_sectors to 1024
Date: Tue, 8 Jul 2014 23:18:38 -0700
Message-ID: <20140709061838.GA28335@infradead.org>
References: <1404886581-3218-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaGIGSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 02:18:39 -0400
Content-Disposition: inline
In-Reply-To: <1404886581-3218-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>

On Wed, Jul 09, 2014 at 08:16:21AM +0200, Hannes Reinecke wrote:
> The DDP offload on ixgbe is only capable of handling requests up
> to 1024 sectors. So we should be exposing this to avoid spurious
> messages about 'not enough user buffers'.

Shouldn't the network driver be able to communicate it's offload
capabilities to the fcoe core?  I'd be happy to take this as an iterim
fix if there's a comment explaining it, but long-term it should be
driver specific.

