From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] 2.5.67+ scsi_release_request call queue next
Date: Tue, 15 Apr 2003 15:39:12 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304151535570.699-100000@ida.rowland.org>
References: <20030415063303.GC1366@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7940 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264039AbTDOT1U
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 15:27:20 -0400
In-Reply-To: <20030415063303.GC1366@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 14 Apr 2003, Mike Anderson wrote:

> This patch is against 2.5.67 as of 04-14 as it needs extern for
> scsi_queue_next_request.
> 
> I just compiled and booted this patch. I currently do not have a setup to
> check door lock post error recovery.

Mike:

I just tried your patch.  I had to make scsi_queue_next_request() 
non-static to get things to link properly, but after doing so it seemed to 
work just fine.  After the door-lock command finished, the request queue 
moved right along and all the data was transferred correctly.

Thanks.

Alan Stern



