From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
Date: Fri, 15 May 2009 09:12:41 +0900
Message-ID: <20090515091134C.fujita.tomonori@lab.ntt.co.jp>
References: <4A0C2297.5040001@panasas.com>
	<4A0C2515.9060602@kernel.org>
	<4A0C2769.4090508@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46160 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZEOANv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 20:13:51 -0400
In-Reply-To: <4A0C2769.4090508@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tj@kernel.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 14 May 2009 17:15:05 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/14/2009 05:05 PM, Tejun Heo wrote:
> > Nice spotting.  Looks like the variable can be killed completely?
> > 
> > Thanks.
> > 
> 
> Sorry yes, here:
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Thu, 14 May 2009 16:46:03 +0300
> Subject: [PATCH] scsi_lib: remove unused variable
> 
> The last request completion cleanup in scsi_lib left an unused
> this_count variable in scsi_io_completion().
> (It was used before in a code segment that now uses blk_end_request_all())
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Ah, I overlooked this.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks,
