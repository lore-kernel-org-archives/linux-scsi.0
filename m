From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 19/21] advansys: Remove a couple of uses of bus_to_virt
Date: Wed, 03 Oct 2007 10:28:31 -0400
Message-ID: <4703A70F.1090500@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376543887-git-send-email-matthew@wil.cx> <4702FAB3.7020608@garzik.org> <20071003123748.GF12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39600 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbXJCO2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 10:28:33 -0400
In-Reply-To: <20071003123748.GF12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> On Tue, Oct 02, 2007 at 10:13:07PM -0400, Jeff Garzik wrote:
>> check dma_map_single for error
> 
> It's on the todo list.  Since so many other drivers don't check
> dma_map_single for error, I feel comfortable with leaving it for later.

The issue became more urgent with x86-64 and its smaller IOMMU area.

	Jeff



