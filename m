From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 08/12] am53c974: BLAST residual handling
Date: Fri, 21 Nov 2014 12:45:05 -0500 (EST)
Message-ID: <20141121.124505.2253067632577581470.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKURpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:45:07 -0500
In-Reply-To: <1416573716-73890-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:52 +0100

> The am53c974 has an design issue where a single byte might be
> left in the SCSI FIFO after a DMA transfer.
> As the handling code is currently untested add a WARN_ON()
> statement here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
