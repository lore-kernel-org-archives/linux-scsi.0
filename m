From: Greg KH <greg@kroah.com>
Subject: Re: Trivial patch for scsi logging text string
Date: Tue, 15 Apr 2003 10:03:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030415170343.GB12357@kroah.com>
References: <20030415063303.GC1366@beaverton.ibm.com> <Pine.LNX.4.44L0.0304151059460.1036-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from granite.he.net ([216.218.226.66]:63498 "EHLO granite.he.net")
	by vger.kernel.org with ESMTP id S261819AbTDOQtn
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 12:49:43 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304151059460.1036-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 15, 2003 at 11:01:31AM -0400, Alan Stern wrote:
> Greg:
> 
> This patch fixes a very minor bobble in a kernel logging string (excess 
> blank space following the \n).  Please apply.
> 
> Alan Stern
> 
> --- 1.34/drivers/scsi/scsi_lib.c	Mon Apr  7 06:33:23 2003
> +++ edited/drivers/scsi/scsi_lib.c	Tue Apr 15 10:58:22 2003

Hm, I don't think I can submit scsi patches to Linus :)
Why not send them to the scsi maintainers...

thanks,

greg k-h
