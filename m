From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] csiostor:fix sparse warnings
Date: Mon, 12 Jan 2015 00:40:46 -0500 (EST)
Message-ID: <20150112.004046.286889948997466119.davem@davemloft.net>
References: <1420818916-12185-1-git-send-email-praveenm@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44507 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbALFkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 00:40:49 -0500
In-Reply-To: <1420818916-12185-1-git-send-email-praveenm@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: praveenm@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@infradead.org, hariprasad@chelsio.com

From: Praveen Madhavan <praveenm@chelsio.com>
Date: Fri,  9 Jan 2015 21:25:16 +0530

> This patch fixes sparse warning reported by kbuild.
> Apply this on net-next since it depends on previous commit.
> 
> drivers/scsi/csiostor/csio_hw.c:259:17: sparse: cast to restricted __le32
> drivers/scsi/csiostor/csio_hw.c:536:31: sparse: incorrect type in assignment
> (different base types)
> drivers/scsi/csiostor/csio_hw.c:536:31:    expected unsigned int [unsigned]
> [usertype] <noident>
> drivers/scsi/csiostor/csio_hw.c:536:31:    got restricted __be32 [usertype]
> <noident>
>>> drivers/scsi/csiostor/csio_hw.c:2012:5: sparse: symbol 'csio_hw_prep_fw' was
> not declared. Should it be static?
> 
> Signed-off-by: Praveen Madhavan <praveenm@chelsio.com>

Applied, thanks.
