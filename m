From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI dynamic power management
Date: Mon, 19 Nov 2007 08:46:50 -0700
Message-ID: <20071119154650.GC12494@parisc-linux.org>
References: <Pine.LNX.4.44L0.0711191028400.4806-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57710 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbXKSPqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 10:46:51 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711191028400.4806-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 19, 2007 at 10:36:19AM -0500, Alan Stern wrote:
> These are conflicting requirements.  How can we send the START-STOP 
> UNIT commands to spin the disk up/down through the request queue while 
> delaying or failing all others?

You can insert commands at the head of a request queue.

> What happens if one of the 
> START-STOP UNIT commands encounters a problem and the error handler 
> needs to send some commands of its own?

It'll do a reset and recover through the normal paths?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
