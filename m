From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
Date: Fri, 21 Dec 2007 11:35:12 +1100
Message-ID: <200712211135.13150.rusty@rustcorp.com.au>
References: <20071220160631S.fujita.tomonori@lab.ntt.co.jp> <200712210958.56994.rusty@rustcorp.com.au> <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:58563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbXLUAfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 19:35:16 -0500
In-Reply-To: <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

On Friday 21 December 2007 11:00:27 FUJITA Tomonori wrote:
> We need to pass the whole sg entries to the IOMMUs at a time.

Hi Fujita,

    OK, it's certainly possible to have an arch override.  For which 
architecture is this BTW?

Thanks,
Rusty.


