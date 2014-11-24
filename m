From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Mon, 24 Nov 2014 16:35:58 +0100
Message-ID: <20141124153558.GA27364@lst.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36743 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaKXPgB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 10:36:01 -0500
Content-Disposition: inline
In-Reply-To: <1416843235-35947-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Nov 24, 2014 at 04:33:55PM +0100, Hannes Reinecke wrote:
> The megaraid SAS driver uses a shared host tag map internally,
> so we should be telling the block layer about it.

But it doesn't make use of request->tag yet.  This would only be
useful if you got rid of the internal tag allocator.

