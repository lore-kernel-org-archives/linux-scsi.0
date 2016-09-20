From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] pas16: remove from tree
Date: Tue, 20 Sep 2016 18:09:10 +0200
Message-ID: <20160920160910.GA28528@lst.de>
References: <1474300253-31351-1-git-send-email-hch@lst.de> <1474300253-31351-6-git-send-email-hch@lst.de> <alpine.LNX.2.00.1609200955490.3516@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50323 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755667AbcITQJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Sep 2016 12:09:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1609200955490.3516@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, schmitzmic@gmail.com, linux@rainbow-software.org

On Tue, Sep 20, 2016 at 10:12:28AM +1000, Finn Thain wrote:
> On that basis, I would remove these drivers along with scsi_register() 
> itself. Is there some reason to remove them earlier? It messes up my patch 
> queue.

Mostly to make the later patches less painless by moving the easy removals
out of the way first.  This also means we have time ahead to resurrect
them properly for the unlikely case that someone cares.

That beeing said I certainly don't want to mess up your patch queue
with this.  How about you pick up the pas16, t128 and dtc patches and
add them to the end of your queue?
