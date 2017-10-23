From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
        requeues
Date: Mon, 23 Oct 2017 08:29:49 +0200
Message-ID: <20171023062949.GA16978@lst.de>
References: <20171003104845.10417-1-hch@lst.de> <20171003104845.10417-10-hch@lst.de> <20171019155933.GE26185@bblock-ThinkPad-W530> <20171020162630.GA14277@lst.de> <20171020164727.GA26380@bblock-ThinkPad-W530> <yq1bmkymlss.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58592 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdJWG3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Oct 2017 02:29:51 -0400
Content-Disposition: inline
In-Reply-To: <yq1bmkymlss.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On Mon, Oct 23, 2017 at 02:16:03AM -0400, Martin K. Petersen wrote:
> 
> Benjamin,
> 
> >> Not sure it's worth it especially now that Martin has merged the patch.
> >
> > He did? I only saw a mail that he picked patches 2-5. So all the bsg
> > changes are still open I think.
> 
> Yes, I expected the bsg bits to go through Jens' tree.

Ok, then I misremembered it, and we'll have to delay the remaining
patches until the next merge window, as they depend on the previous
ones.
