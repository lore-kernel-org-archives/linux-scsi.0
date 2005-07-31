From: Christoph Hellwig <hch@infradead.org>
Subject: Re: support for old megaraid cards in megraid_mbox
Date: Sun, 31 Jul 2005 15:07:40 +0100
Message-ID: <20050731140740.GA6321@infradead.org>
References: <20050610231103.GA17504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38571 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261803AbVGaOHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 10:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20050610231103.GA17504@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreenib@lsil.com, sju@lsil.com
Cc: linux-scsi@vger.kernel.org

On Sat, Jun 11, 2005 at 12:11:03AM +0100, Christoph Hellwig wrote:
> is there a technical reason the PCI_DEVICE_ID_AMI_MEGARAID and
> PCI_DEVICE_ID_AMI_MEGARAID2 cards are supported in the old
> megraid driver, but not in megaraid_mbox?  It would be a real
> pain to keep the old driver around just for those two cards.

It looks like those aren't actually supported.  So is it fine with
LSI to remove all but the two above PCI IDs from the driver?  Also
it would be nice if you could point out what code pathes we can remove
in the old megaraid driver, e.g. do the old cards use pio only?
