From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 05/12] esp_scsi: read status registers
Date: Fri, 21 Nov 2014 12:44:13 -0500 (EST)
Message-ID: <20141121.124413.1707508705778313354.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKURoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:44:16 -0500
In-Reply-To: <1416573716-73890-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:49 +0100

> A read to ESP_INTRPT will clear ESP_STATUS and ESP_SSTEP. So read
> all status registers in one go to avoid losing information.
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
