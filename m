From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 14:19:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617131903.GA31775@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD23FF9@otce2k03.adaptec.com> <20040617130713.GX20511@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:31915 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266494AbUFQNTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 09:19:06 -0400
Content-Disposition: inline
In-Reply-To: <20040617130713.GX20511@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 17, 2004 at 02:07:13PM +0100, Matthew Wilcox wrote:
> It's a hard problem.  Where's the right tradeoff?  I have a system that
> has a memory map that puts the first 3.75GB of memory at 0, then the
> next 256MB at 64GB, then continues from 4GB.  If there's only 4GB of
> RAM in that system, I'm sure you'd rather use 32-bit descriptors and
> anything in that 256MB gets bounce-buffered.

With the SGI iommu it doesn't matter how much memory you have anyway,
if you're using DAC you'll always get high bits set in your dma address.
I suspect many other iommus work the same.

