From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 09/12] esp: correctly detect am53c974
Date: Fri, 21 Nov 2014 12:46:43 -0500 (EST)
Message-ID: <20141121.124643.1355739475835199583.davem@davemloft.net>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
	<1416573716-73890-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36573 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaKURqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 12:46:45 -0500
In-Reply-To: <1416573716-73890-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: jbottomley@parallels.com, hch@lst.de, pbonzini@redhat.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>
Date: Fri, 21 Nov 2014 13:41:53 +0100

> +		if ((config4 & ESP_CONFIG4_GE1) == ESP_CONFIG4_GE1) {

Please condense this down to the more simple and straightforward:

	if (x & BIT(N))

because this is always equivalent to the expression you have used:

	if ((x & BIT(N)) == BIT(N))

Thanks.
