From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] block: add lld busy state exporting interface
Date: Wed, 1 Oct 2008 20:31:08 +0200
Message-ID: <20081001183107.GM19428@kernel.dk>
References: <20080929.113558.112628070.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:35232 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbYJASb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 14:31:27 -0400
Content-Disposition: inline
In-Reply-To: <20080929.113558.112628070.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, akpm@linux-foundation.org, j-nomura@ce.jp.nec.com

On Mon, Sep 29 2008, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> I hope the previous RFC patch(*) would be no problem, since I haven't
> gotten any negative comment.
>     (*) http://lkml.org/lkml/2008/9/25/262
> 
> So could you take this patch for 2.6.28 additionally?
> This patch adds a new interface for request stacking drivers.
> There should be no regression risk.
> 
> This patch was created on top of the commit below of for-2.6.28.
> ---------------------------------------------------------------------
> commit e857b07acc3f1352224f380fcbf26ef985116cc8
> Author: Sven Schuetz <sven@linux.vnet.ibm.com>
> Date:   Fri Sep 26 10:58:02 2008 +0200
> 
>     include blktrace_api.h in headers_install
> ---------------------------------------------------------------------

Applied

-- 
Jens Axboe

