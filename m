From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix comment typo in Scsi_Host struct definition
Date: Fri, 17 Oct 2014 06:24:54 -0700
Message-ID: <20141017132454.GL16538@infradead.org>
References: <20141009124007.14ea0a3d09813fc593e1dc21@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaJQNYz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:24:55 -0400
Content-Disposition: inline
In-Reply-To: <20141009124007.14ea0a3d09813fc593e1dc21@clara.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 09, 2014 at 12:40:07PM +0100, Mark Knibbs wrote:
> Hi,
> 
> The comment for the max_channel, max_id and max_lun parameters
> refers to the first two, but actually means the last two.
> 
> Signed-off-by: Mark Knibbs <markk@clara.co.uk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
