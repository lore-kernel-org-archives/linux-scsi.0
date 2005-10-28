From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] tidy up scsi_error_handler
Date: Fri, 28 Oct 2005 17:28:43 -0600
Message-ID: <20051028232843.GC21871@parisc-linux.org>
References: <20051028230155.GA13083@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:26061 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750757AbVJ1X2q
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 19:28:46 -0400
Content-Disposition: inline
In-Reply-To: <20051028230155.GA13083@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Oct 29, 2005 at 01:01:55AM +0200, Christoph Hellwig wrote:
>  	/*
> -	 * Note - we always use TASK_INTERRUPTIBLE even if the module
> -	 * was loaded as part of the kernel.  The reason is that
> -	 * UNINTERRUPTIBLE would cause this thread to be counted in
> -	 * the load average as a running process, and an interruptible
> -	 * wait doesn't.
> +	 * We use TASK_INTERRUPTIBLE so that the thread is not
> +	 * counted against the load average as a running process.
> +	 * We never actually get interrupted because kthread_run
> +	 * disables singal delivery for the created thread.

tpyo "signal".

