From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 06/12] esp_scsi: use FIFO for command submission
Date: Fri, 21 Nov 2014 12:42:06 -0500 (EST)
Message-ID: <20141121.124206.803554152911630876.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36410 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaKURmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:42:10 -0500
In-Reply-To: <1416573716-73890-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:50 +0100

> Using DMA for command submission has the drawback that it might
> generate additional DMA completion interrupts after the command
> has been submitted to the device.
> Additionally the am53c974 has a design flaw causing it
> to generate spurious interrupts even though DMA completion
> interrupts are not enabled.
> This can be avoided by using the FIFO for command submission.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
