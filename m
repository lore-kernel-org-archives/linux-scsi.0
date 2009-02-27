From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Fri, 27 Feb 2009 16:50:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902271610450.4121-100000@iolanthe.rowland.org>
References: <49A8021E.1050503@cybernetics.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760810AbZB0Vuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 16:50:52 -0500
In-Reply-To: <49A8021E.1050503@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Feb 2009, Tony Battersby wrote:

> I tested Alan's original patch with sym53c8xx back in January:
> 
> http://marc.info/?l=linux-scsi&m=123143710010939&w=4
> 
> Tested-by: Tony Battersby <tonyb@cybernetics.com>

Thanks for the support.  I must have missed your post when it appeared
last month.

In fact, I don't care which approach gets accepted: James's or my own.  
His has the advantage of being somewhat shorter and not changing the
order of events during host creation.

On the other hand, James, your suggested patch is definitely wrong,
for a trivial reason.  You moved the scsi_proc_hostdir_rm() call into
scsi_host_put() instead of scsi_host_dev_release(), where it belongs.
I'll post a corrected version shortly.

Alan Stern

