From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 03/12] esp_scsi: convert to dev_printk
Date: Fri, 21 Nov 2014 12:43:15 -0500 (EST)
Message-ID: <20141121.124315.463338299809344251.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36506 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKURnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:43:17 -0500
In-Reply-To: <1416573716-73890-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:47 +0100

> Use dev_printk functions for correct device annotations.
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
