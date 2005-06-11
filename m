From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] aic7xxx: do not check for duplicate pci ids
Date: Sat, 11 Jun 2005 20:37:31 +0200
Message-ID: <20050611183731.GA25078@lst.de>
References: <20050610221531.GC8706@lst.de> <20050611183435.GB3019@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50890 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261781AbVFKShg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:37:36 -0400
Content-Disposition: inline
In-Reply-To: <20050611183435.GB3019@pentafluge.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pentafluge.infradead.org
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 07:34:35PM +0100, jgarzik@pentafluge.infradead.org wrote:
> On Sat, Jun 11, 2005 at 12:15:31AM +0200, Christoph Hellwig wrote:
> > pci layer handles this just fine for us
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Is there a similar patch for aic79xx?

and equivalent patch would apply, but probably conflict with other
pending changes.  Let's get transport class support finished for
aic79xx adn then we can port over misc cleanups.
