From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Future writeback topics
Date: Mon, 23 Jan 2012 15:19:04 -0500
Message-ID: <20120123201904.GN25986@redhat.com>
References: <4F1C141C.2050704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab2AWUTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 15:19:40 -0500
Content-Disposition: inline
In-Reply-To: <4F1C141C.2050704@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Sun, Jan 22, 2012 at 03:50:20PM +0200, Boaz Harrosh wrote:
> Hi
> 
> Now that we have the "IO-less dirty throttling" in and kicking (ass I might say)
> Are there plans for second stage? I can see few areas that need some love.
> 
> [IO Fairness, time sorted writeback, properly delayed writeback]
> 
>   As we started to talk about in another thread: "[LSF/MM TOPIC] a few storage topics"
>   I would like to propose the following topics:
> 
> * Do we have enough information for the time of dirty of pages, such as the
>   IO-elevators information, readily available to be used at the VFS layer.

Assuming it is available, what's the plan. How would VFS layer make use
of it?

Thanks
Vivek
