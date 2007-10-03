From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/16] gdth: split out isa probing
Date: Wed, 03 Oct 2007 12:00:28 -0400
Message-ID: <4703BC9C.6050503@garzik.org>
References: <46FFFC8C.6080804@panasas.com> <46FFFDE9.3010500@panasas.com> <200710021918.11183.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49254 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbXJCQAt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 12:00:49 -0400
In-Reply-To: <200710021918.11183.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Rolf Eike Beer wrote:
> What we have here is cleanly not PCI memory as it's ISA initialisation. And 
> for making things obvious passing NULL as first argument of 
> dma_alloc_consistent() is IMHO the better way.


While this is true, this is largely a code movement patch.

It's up to Boaz/Christoph whether they want to include another cleanup 
in this patch, or move that to separate patch that switches the driver 
to dma_xxx

	Jeff


