From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Tue, 15 Jul 2003 14:36:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030715213631.GA3911@beaverton.ibm.com>
References: <20030713141556.13650fdb.akpm@osdl.org> <20030714101041.65de0d72.akpm@osdl.org> <20030714203510.GE1317@beaverton.ibm.com> <200307152143.26772.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:22499 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S269736AbTGOVTS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 17:19:18 -0400
Content-Disposition: inline
In-Reply-To: <200307152143.26772.arvidjaar@mail.ru>
List-Id: linux-scsi@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, hch@infradead.org, linux-scsi@vger.kernel.org

Andrey Borzenkov [arvidjaar@mail.ru] wrote:
> There are still remaining problems. Sorry if they are already known.
> 
> 1. Removing USB memory stick without unmounting file system first results in 
> dead system. It crashes in several seconds with stack (sorry, had to write 
> down manually)
> 
> sync_sb_inodes+0x97/0x2f0
> writeback_inodes
> wb_kupdate
> __pdflush
> schedule_tail
> pdflush_+0x00/0x20
> pdflush_0xf/0x20
> wb_kupdate
> kernel_thread_helper
> 
> Only Alt-Sysrq-B works after that.
> 
> 2.0.0-test1 + this patch + my ppa patch
> 
> This is currently showstopper for me :(
> 

I previously posted a patch to linux-scsi for scsi host and scsi device
ref count cleanups. The thread is available here:
http://marc.theaimsgroup.com/?t=105770318200001&r=1&w=2

I have updated the patch with comments, but still want to finish a change
to scsi_free_sdev and do some testing before I send it out again.

I do not run devfs currently so I have not seen the issue related to
devfs.

-andmike
--
Michael Anderson
andmike@us.ibm.com

