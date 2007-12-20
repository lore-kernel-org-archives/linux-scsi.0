From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 16:07:41 +0900
Message-ID: <20071220160741K.fujita.tomonori@lab.ntt.co.jp>
References: <200712201645.19035.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:46036 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXLTHIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 02:08:10 -0500
In-Reply-To: <200712201645.19035.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Thu, 20 Dec 2007 16:45:18 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> OK, some fixes since last time, as I wade through more SCSI drivers.  Some 
> drivers use "use_sg" as a flag to know whether the request_buffer is a 
> scatterlist: I don't need the counter, but I still need the flag, so I fixed 
> that in a more intuitive way (an explicit ->sg pointer in the cmd).

use_sg and the request_buffer will be removed shortly.

http://marc.info/?l=linux-scsi&m=119754650614813&w=2


I think that we tried the similar idea before, scsi_sgtable, but we
seem to settle in the current simple approach.
