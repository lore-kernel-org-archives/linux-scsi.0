From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 19/21] advansys: Remove a couple of uses of bus_to_virt
Date: Tue, 02 Oct 2007 22:13:07 -0400
Message-ID: <4702FAB3.7020608@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376543887-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38715 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXJCCNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:13:09 -0400
In-Reply-To: <1191376543887-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Replace ASC_VADDR_TO_U32 and ASC_U32_TO_VADDR with an auto-expanding
> array that maps pointers to 32-bit IDs and back.  One of the uses of
> ASC_VADDR_TO_U32 was in error; it should have been using ADV_VADDR_TO_U32.
> 
> Also replace the use of virt_to_bus when setting the sense_address with
> a call to dma_map_single() followed by dma_cache_sync.  This part cribbed
> from the 53c700 driver.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

check dma_map_single for error


