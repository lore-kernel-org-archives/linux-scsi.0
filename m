From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Date: Thu, 22 Feb 2007 21:45:02 +0000
Message-ID: <20070222214502.GA19670@infradead.org>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXBVVpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 16:45:15 -0500
Content-Disposition: inline
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org

On Thu, Feb 22, 2007 at 03:38:45PM -0600, Mike Miller (OS Dev) wrote:
> Patch 2/2
> 
> This adds support for struct pci_driver shutdown and negates the previous NAK'ed
> reboot_notifier patch. It's much easier, wish I had know about this before. Thanks to
> Christoph for pointing this out.

Just sondering, where should we have put information about this so driver
writers/maintainers like you would have found it easily?

