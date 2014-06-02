From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] mpt2sas: annotate ioc->reply_post_host_index as
 __iomem
Date: Mon, 2 Jun 2014 09:32:33 -0700
Message-ID: <20140602163233.GD26828@infradead.org>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
 <1401719912-18532-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaFBQcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:32:33 -0400
Content-Disposition: inline
In-Reply-To: <1401719912-18532-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Mon, Jun 02, 2014 at 10:38:32AM -0400, Joe Lawrence wrote:
> The MPT2SAS_ADAPTER reply_post_host_index[] holds calculated addresses
> in memory mapped register space.  Add an "__iomem" annotation to silence
> the following sparse warnings:

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
