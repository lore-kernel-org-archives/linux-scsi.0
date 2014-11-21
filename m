From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 11/12] esp: enable CONFIG2_FENAB for am53c974
Date: Fri, 21 Nov 2014 12:47:50 -0500 (EST)
Message-ID: <20141121.124750.1570878008450516879.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36589 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaKURrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:47:52 -0500
In-Reply-To: <1416573716-73890-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:55 +0100

> CONFIG2_FENAB ('feature enable') changed definition between chip
> revisions, from 'Latch SCSI Phase' to 'Latch SCSI Phase, display
> chip ID upon reset, and enable 24 bit addresses'.
> So only enable it for am53c974 where we know what it's doing.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
