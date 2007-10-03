From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 20/21] advansys: Use dma mapping for overrun buffer
Date: Tue, 02 Oct 2007 22:11:07 -0400
Message-ID: <4702FA3B.80101@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432212-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38706 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbXJCCLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:11:08 -0400
In-Reply-To: <11913765432212-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Convert the call to virt_to_bus() into a call to dma_map_single().  Some
> architectures may require different DMA addresses for different devices,
> so allocate one overrun buffer per host rather than one for all cards.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

check dma_map_single() for error

ACK, once that is done


