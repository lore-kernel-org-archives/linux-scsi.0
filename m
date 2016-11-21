From: Christoph Hellwig <hch@lst.de>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Mon, 21 Nov 2016 15:06:37 +0100
Message-ID: <20161121140637.GA15774@lst.de>
References: <1479395693-5781-1-git-send-email-hch@lst.de> <96e879ef-3152-f133-b89d-ae3f2661a85e@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38126 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752505AbcKUOGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:06:39 -0500
Content-Disposition: inline
In-Reply-To: <96e879ef-3152-f133-b89d-ae3f2661a85e@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, hare@suse.de, linux-scsi@vger.kernel.org

On Fri, Nov 18, 2016 at 08:21:35AM -0800, James Smart wrote:
> Hi Christoph,
>
> We had already done this work in the larger lpfc patch that had been posted 
> for nvme work.

Which one is that?

>
> I'll look at separating out just the irq part and post a reply.

Thanks.
