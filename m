From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] gdth: remove redundant PCI stuff
Date: Tue, 17 Jul 2007 20:15:18 +0100
Message-ID: <20070717191518.GA8955@infradead.org>
References: <20070717092517.GA28201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbXGQTPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 15:15:30 -0400
Content-Disposition: inline
In-Reply-To: <20070717092517.GA28201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Jul 17, 2007 at 05:25:17AM -0400, Jeff Garzik wrote:
> This patch
> 
> * removes struct members that duplicate pci_dev members
> * replaces ha->stype usage with ha->pdev->device usage where feasible

These two bits look nice.

> * removes PCI IDs that are already in include/linux/pci_ids.h

note sure about this one.  The list of partially unused pci ids in the
header is one of the few guidelines what pci ids are actually supported
by this driver.

And btw, please Cc Achim on your patches, he still maintains the driver
although it sometimes seems hard to actually get your patches into his
inbox.

