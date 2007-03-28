From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] improve bsg device allocation
Date: Wed, 28 Mar 2007 13:30:30 +0200
Message-ID: <20070328113030.GN3963@kernel.dk>
References: <20070322031106Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:19643 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393AbXC1LbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 07:31:05 -0400
Content-Disposition: inline
In-Reply-To: <20070322031106Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 22 2007, FUJITA Tomonori wrote:
> This patch addresses on two issues on bsg device allocation.
> 
> - the current maxium number of bsg devices is 256. It's too small if
> we allocate bsg devices to all SCSI devices, transport entities, etc.
> This increses the maxium number to 32768 (taken from the sg driver).
> 
> - SCSI devices are dynamically added and removed. Currently, bsg can't
> handle it well since bsd_device->minor is simply increased.
> 
> This is dependent on the patchset that I posted yesterday:
> 
> http://marc.info/?l=linux-scsi&m=117440208726755&w=2

applied

-- 
Jens Axboe

