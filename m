From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.6.3-mm4 scsi_delete_timer() oops
Date: 13 Mar 2004 23:27:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079238471.1759.74.camel@mulgrave>
References: <20040314041047.GK655@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52959 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263273AbUCNE14 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 23:27:56 -0500
In-Reply-To: <20040314041047.GK655@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sat, 2004-03-13 at 23:10, William Lee Irwin III wrote:
> Mar 13 19:41:59 holomorphy kernel: EIP:    0060:[<00000000>]    Not tainted VLI
[...]
> Mar 13 19:41:59 holomorphy kernel:  [<c0358076>] scsi_delete_timer+0x16/0x30
> Mar 13 19:41:59 holomorphy kernel:  [<c0373de9>] ahc_linux_run_complete_queue+0x69/0xd0

This trace doesn't make sense to me.  A null EIP usually indicates
jumping through a NULL function pointer.  There are no fptr derefs in
scsi_delete_timer.  Also ahc_linux_run_complete_queue doesn't call
scsi_delete_timer.

Could you try to reproduce and get a more meaningful backtrace?

Thanks,

James


