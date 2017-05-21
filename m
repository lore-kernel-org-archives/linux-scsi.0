From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH blktests 0/3] Add SCSI generic test group
Date: Sun, 21 May 2017 00:03:22 -0700
Message-ID: <20170521070322.GA10453@infradead.org>
References: <cover.1495109149.git.jthumshirn@suse.de>
 <20170518131928.GA26060@infradead.org>
 <94150f71-5bbb-2ee2-b7d4-d0f2f7124684@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdEUHDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2017 03:03:25 -0400
Content-Disposition: inline
In-Reply-To: <94150f71-5bbb-2ee2-b7d4-d0f2f7124684@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Omar Sandoval <osandov@osandov.com>, Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Thu, May 18, 2017 at 03:29:45PM +0200, Johannes Thumshirn wrote:
> On 05/18/2017 03:19 PM, Christoph Hellwig wrote:
> > All SG_IO test should also apply to block device nodes that support
> > the ioctl..
> > 
> 
> But these are not necessarily SG_IO tests, are they?
> 
> The test included is doesn't hit the SG_IO path in the sg driver, but
> the sg_read path.

Oh, you're right.

> 
> Of cause we can make a generic sg_io tool but IMHO it's quite convenient
> to just throw in the reproducers we get.
> 
> And as it exercises the /dev/sg character device I decided to make a new
> group.

Yeah, makes sense.  And any SG_IO test should be able to run on
both block device nodes and sg nodes.
