From: Willem Riede <wrlk@riede.org>
Subject: Re: ide-scsi error handling
Date: Mon, 19 May 2003 19:42:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519234254.GG19202@linnie.riede.org>
References: <20030518230706.GA19202@linnie.riede.org> <3EC8D5A3.8020600@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:64760
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S263348AbTESX1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 19:27:41 -0400
Content-Disposition: inline
In-Reply-To: <3EC8D5A3.8020600@torque.net>; from dougg@torque.net on Mon, May 19, 2003 at 09:01:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, rddunlap@osdl.org

On 2003.05.19 09:01, Douglas Gilbert wrote:
> Debug: sleeping function called from illegal context at include/linux/rwsem.h:43
> Call Trace:
>  [<c011f92c>] __might_sleep+0x5c/0x5e
>  [<c011b2d8>] do_page_fault+0x78/0x4a8
>  [<e0823c4b>] idescsi_transfer_pc+0xfb/0x130 [ide_scsi]

A page fault while in idescsi_transfer_pc?!
What memory would be accessed that is allowed to be paged out?

By the way, I have never seen that problem. When ide-scsi fails for me, it
is in the same way Randy reports. While my change improves mean-time-to-hang
significantly on my machine, it obviously doesn't for Randy. Back to the
drawing board :-(

Thanks, Willem Riede.
