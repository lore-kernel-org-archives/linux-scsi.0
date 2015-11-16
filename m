From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Mon, 16 Nov 2015 18:22:49 +0100
Message-ID: <20151116172249.GA576@lst.de>
References: <1447610393-2899-1-git-send-email-hch@lst.de> <564A0F56.8060408@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52801 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbbKPRWv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2015 12:22:51 -0500
Content-Disposition: inline
In-Reply-To: <564A0F56.8060408@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

Hi Bart,

the code in this area changed enough since 4.3 that it won't easily
apply.  But a backport would still be very useful!
