From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/7] powerpc: remove the legacy iSeries platform
 specific drivers
Date: Wed, 07 Mar 2012 22:53:01 -0800 (PST)
Message-ID: <20120307.225301.360050313988337392.davem@davemloft.net>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:58204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CHG5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2012 01:57:37 -0500
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sfr@canb.auug.org.au
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, JBottomley@parallels.com, netdev@vger.kernel.org, alan@linux.intel.com, brking@linux.vnet.ibm.com, gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Mar 2012 15:28:53 +1100

> It would probably be easiest if all these patches were merged via the
> powerpc tree to eliminate any dependencies between them.  Their impact on
> generic code is very small.

No objections.
