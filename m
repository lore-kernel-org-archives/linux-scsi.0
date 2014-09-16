From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3] scsi: fix build errors, SCSI_FC_ATTRS needs to
 depend on SCSI && NET
Date: Tue, 16 Sep 2014 00:07:23 -0400 (EDT)
Message-ID: <20140916.000723.1605333026296804622.davem@davemloft.net>
References: <1410813921-24400-1-git-send-email-anish@chelsio.com>
	<1410813921-24400-2-git-send-email-anish@chelsio.com>
	<5417825A.4050902@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44318 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaIPEH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2014 00:07:26 -0400
In-Reply-To: <5417825A.4050902@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rdunlap@infradead.org
Cc: anish@chelsio.com, netdev@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, mchan@broadcom.com, eddie.wai@broadcom.com, jim.epost@gmail.com

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 15 Sep 2014 17:20:42 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors when CONFIG_SCSI_NETLINK is enabled but
> CONFIG_NET is not enabled:
 ...
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks a lot Randy.
