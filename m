From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: iovec support
Date: Mon, 19 Mar 2007 23:21:13 +0900
Message-ID: <20070319232113N.fujita.tomonori@lab.ntt.co.jp>
References: <45FE8887.8040901@torque.net>
	<20070319184305U.fujita.tomonori@lab.ntt.co.jp>
	<45FE987D.5070908@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:62401 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXCSOUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 10:20:24 -0400
In-Reply-To: <45FE987D.5070908@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, pw@osc.edu, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] bsg: iovec support
Date: Mon, 19 Mar 2007 10:04:45 -0400

> >> Pete is also suggesting (shown above) a revised sg_io_vec
> >> structure that uses a uint64_t for the pointer to simplify
> >> 32, 64 bit thunking.
> > 
> > All I said is that it would be better to use the existing compat
> > infrastructure (sg_build_iovec, sg_ioctl_trans, etc in
> > fs/compat_ioctl.c) instead of adding another compat code.
> 
> Won't sg v4 make this even a bigger mess, at least
> initially anyway?

Inventing a new iovec structure like sg_io_v4_vec and something like
blk_rq_map_user_iov_sgv4 sounds a mess.
