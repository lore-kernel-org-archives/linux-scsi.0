From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] 2.5.67+ scsi_release_request call queue next
Date: Tue, 15 Apr 2003 15:36:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030415223614.GA1206@beaverton.ibm.com>
References: <20030415063303.GC1366@beaverton.ibm.com> <Pine.LNX.4.44L0.0304151535570.699-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:59550 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264129AbTDOWWh
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 18:22:37 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304151535570.699-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike:
> 
> I just tried your patch.  I had to make scsi_queue_next_request() 
> non-static to get things to link properly, but after doing so it seemed to 
> work just fine.  After the door-lock command finished, the request queue 
> moved right along and all the data was transferred correctly.

Good to see it worked. The non-static change should be in the bk current
tree already.

-andmike
--
Michael Anderson
andmike@us.ibm.com

