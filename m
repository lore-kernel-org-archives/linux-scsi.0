From: David Miller <davem@davemloft.net>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 17:09:33 -0500 (EST)
Message-ID: <20141124.170933.410328396352735176.davem@davemloft.net>
References: <547367DF.5060706@kernel.dk>
	<20141124.165623.42259031853400756.davem@davemloft.net>
	<5473AAD3.7010409@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54344 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXWJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 17:09:36 -0500
In-Reply-To: <5473AAD3.7010409@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: paulmck@linux.vnet.ibm.com, hch@infradead.org, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 24 Nov 2014 15:01:55 -0700

> I'll just updated blk-mq to use nr_cpu_ids and be done with it.

Wow, a grep on nr_cpu_ids gets a lot of hits on people allocating just
these kinds of tables :)
