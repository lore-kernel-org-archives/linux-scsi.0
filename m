From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 3 Oct 2007 18:27:37 +0100
Message-ID: <20071003172737.GA6446@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <46FFFE21.4030902@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXJCR2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 13:28:08 -0400
Content-Disposition: inline
In-Reply-To: <200710021920.40354.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Oct 02, 2007 at 07:20:38PM +0200, Rolf Eike Beer wrote:
> Same thing as in ISA patch: this is not PCI and we should not hide what we're 
> doing so dma_alloc_consistent(NULL, ...) is better IMHO.

passing NULL is the documented way to deal with ISA/EISA devices with
the old pci dma api.  Any change to these APIs should be a different
patch, and there's about 100 more important things in gdth right now.
