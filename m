From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: 2.6.3-mm4 scsi_delete_timer() oops
Date: Sat, 13 Mar 2004 20:34:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314043420.GL655@holomorphy.com>
References: <20040314041047.GK655@holomorphy.com> <1079238471.1759.74.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from holomorphy.com ([207.189.100.168]:14604 "EHLO holomorphy.com")
	by vger.kernel.org with ESMTP id S263100AbUCNEeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 23:34:24 -0500
Content-Disposition: inline
In-Reply-To: <1079238471.1759.74.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sat, 2004-03-13 at 23:10, William Lee Irwin III wrote:
>> Mar 13 19:41:59 holomorphy kernel: EIP:    0060:[<00000000>]    Not tainted VLI
> [...]
>> Mar 13 19:41:59 holomorphy kernel:  [<c0358076>] scsi_delete_timer+0x16/0x30
>> Mar 13 19:41:59 holomorphy kernel:  [<c0373de9>] ahc_linux_run_complete_queue+0x69/0xd0

On Sat, Mar 13, 2004 at 11:27:50PM -0500, James Bottomley wrote:
> This trace doesn't make sense to me.  A null EIP usually indicates
> jumping through a NULL function pointer.  There are no fptr derefs in
> scsi_delete_timer.  Also ahc_linux_run_complete_queue doesn't call
> scsi_delete_timer.
> Could you try to reproduce and get a more meaningful backtrace?

I'm pretty stumped as to what's going on with this. The stack is
moderately deep. It's also possible a fair fraction of the stuff is
garbage off the end of the stack and the real leaf routine is buried.


-- wli
