From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Thu, 29 Nov 2007 22:26:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711292213500.12541-100000@netrider.rowland.org>
References: <20071129151842.44c05b18.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3100 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934923AbXK3Ddb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2007 22:33:31 -0500
In-Reply-To: <20071129151842.44c05b18.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Reid <joereid@gmail.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Albert Lee <albertcc@tw.ibm.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 29 Nov 2007, Andrew Morton wrote:

> Guys, I have this marked as needed-in-2.6.24?

> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8904
> 
> An updated (by Albert, I assume) version of the fourteen-month-old patch here:
> 
> http://marc.info/?l=linux-kernel&m=115412002912837&w=2
> 
> Apparently fixes the bug described at
> http://bugzilla.kernel.org/show_bug.cgi?id=8904
> 
> Needs some TLC.  Perhaps urgently.

As far as I'm concerned there's no harm in leaving it until 2.6.25; my
original version was only a slight performance optimization to prevent
excessive querying when the answer is known beforehand.  In fact this
version of the patch includes only a portion of my original submission.  
The part in sd.c that exits the retry loop early when there's no medium
is missing.

But if this really does fix bug #8904 then it should go in sooner.  
The question is, does it fix the bug?  The report mentions only a small 
amount of testing.

Alan Stern

