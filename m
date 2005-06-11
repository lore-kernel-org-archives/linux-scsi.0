From: jgarzik@pentafluge.infradead.org
Subject: Re: [PATCH] aic7xxx: do not check for duplicate pci ids
Date: Sat, 11 Jun 2005 19:34:35 +0100
Message-ID: <20050611183435.GB3019@pentafluge.infradead.org>
References: <20050610221531.GC8706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19844 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261781AbVFKSej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:34:39 -0400
Content-Disposition: inline
In-Reply-To: <20050610221531.GC8706@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 12:15:31AM +0200, Christoph Hellwig wrote:
> pci layer handles this just fine for us
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Is there a similar patch for aic79xx?

	Jeff



