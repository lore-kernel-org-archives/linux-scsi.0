From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Scatter Gather question : 2.6.test4 . page to vaddr
Date: 22 Sep 2003 15:34:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064262866.15409.135.camel@mulgrave>
References: <20030922201540.68358.qmail@web60210.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:18951 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263279AbTIVUnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:43:06 -0400
In-Reply-To: <20030922201540.68358.qmail@web60210.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: dead_emaill@nospam.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2003-09-22 at 15:15, jd wrote:
> I see that 2.6 scatterlist.h has eliminated the "address" element
> and uses page struct only, and that  pci_map_sg() is used to 
> populate the dma_address field. I'm not really planning on
> using DMA .
> 
> How can I convert the page * entry 
> pointed to by  SCpnt->request_buffer   back to a vaddr ? 
> I don't see a page-to-vaddr() . function ?
> Thanks for any insight.

In general, you can't...the page may not be mapped in the kernel's
space.  You can use kmap/kunmap to look at its contents.

James


