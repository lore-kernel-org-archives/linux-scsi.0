From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 10/12] esp_scsi: let DMA driver provide a config2 value
Date: Fri, 21 Nov 2014 12:47:40 -0500 (EST)
Message-ID: <20141121.124740.527377319990695594.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36581 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKURrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:47:43 -0500
In-Reply-To: <1416573716-73890-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:54 +0100

> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> On PCscsi, the FENAB configuration also enables 24-bit DMA
> transfer lengths (and provides the chip id in TCHI after reset).
> We want to be able to enable this parameter from the DMA driver.
> 
> Check if the caller of scsi_esp_register provided a value for esp->config2.
> If this is the case, assume this is not an ESP100, skip the detection
> phase and leave esp->config2 untouched.  It will be used in esp_reset_esp.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
