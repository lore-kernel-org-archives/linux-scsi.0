From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cxgb4/csiostor: Don't use MASTER_MUST for fw_hello call
Date: Thu, 11 Dec 2014 14:25:43 -0500 (EST)
Message-ID: <20141211.142543.465362034244812431.davem@davemloft.net>
References: <1418276503-23001-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:55751 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbaLKTZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 14:25:46 -0500
In-Reply-To: <1418276503-23001-1-git-send-email-hariprasad@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hariprasad@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@infradead.org, leedom@chelsio.com, anish@chelsio.com, nirranjan@chelsio.com, praveenm@chelsio.com

From: Hariprasad Shenai <hariprasad@chelsio.com>
Date: Thu, 11 Dec 2014 11:11:43 +0530

> Remove use of calls into t4_fw_hello() with MASTER_MUST, which results in
> FW_HELLO_CMD_MASTERFORCE being set. The firmware doesn't support this and of
> course any existing PF Drivers will totally go for a toss.
> 
> Signed-off-by: Hariprasad Shenai <hariprasad@chelsio.com>

Applied, thanks.
