From: Christoph Hellwig <hch@lst.de>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Sun, 8 Jan 2017 16:02:42 +0100
Message-ID: <20170108150242.GA29654@lst.de>
References: <1479395693-5781-1-git-send-email-hch@lst.de> <96e879ef-3152-f133-b89d-ae3f2661a85e@broadcom.com> <20161121140637.GA15774@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60819 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdAHPCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 8 Jan 2017 10:02:44 -0500
Content-Disposition: inline
In-Reply-To: <20161121140637.GA15774@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, hare@suse.de, linux-scsi@vger.kernel.org

On Mon, Nov 21, 2016 at 03:06:37PM +0100, Christoph Hellwig wrote:
> On Fri, Nov 18, 2016 at 08:21:35AM -0800, James Smart wrote:
> > Hi Christoph,
> >
> > We had already done this work in the larger lpfc patch that had been posted 
> > for nvme work.
> 
> Which one is that?
> 
> >
> > I'll look at separating out just the irq part and post a reply.
> 
> Thanks.

Any progress on this?  Now that 4.10-rc has NVMe-FC core support it
would also be good to get the lpfc code out for review.
