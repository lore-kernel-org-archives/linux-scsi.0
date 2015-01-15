From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] Remove T4 FCoE support
Date: Thu, 15 Jan 2015 14:04:53 -0500 (EST)
Message-ID: <20150115.140453.871607276763972458.davem@davemloft.net>
References: <cover.1421328605.git.praveenm@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54207 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbAOTEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2015 14:04:55 -0500
In-Reply-To: <cover.1421328605.git.praveenm@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: praveenm@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com, varun@chelsio.com

From: Praveen Madhavan <praveenm@chelsio.com>
Date: Thu, 15 Jan 2015 19:15:50 +0530

> These patches removes FCoE support for chelsio T4 adapter.
> Please apply on net-next since depends on previous commits.

Why is it being removed?  You have to state this in the
commit log messages at a minimum.
