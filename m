From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Wed, 1 Jun 2005 14:57:32 -0700
Message-ID: <20050601215732.GA27734@us.ibm.com>
References: <1117659647.5047.52.camel@mulgrave> <Pine.LNX.4.44L0.0506011708410.5912-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41867 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261252AbVFAV5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 17:57:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j51Lvmfv030409
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 17:57:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j51LvmLI130322
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 17:57:48 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j51LvlG7005248
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 17:57:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506011708410.5912-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Jun 01, 2005 at 05:26:34PM -0400, Alan Stern wrote:
> On Wed, 1 Jun 2005, James Bottomley wrote:
> 
> > On Wed, 2005-06-01 at 14:45 -0400, Alan Stern wrote:
> > > Has there been any more progress on this issue?
> > 
> > Well, the patch is in scsi-misc, if that's what you're asking.
> 
> That's good.  Is it too much to ask for an additional patch to zero out
> the sense data buffer after the error handler has finished with a command?  
> After a transport error or a timeout there shouldn't be any sense data
> (races aside), but the error handler often leaves apparently valid data in
> the buffer, unrelated to the original command.

I was hoping someone else might comment on that, I am not certain if sense
data is valid only when CHECK_CONDITION is set. 

But, we can zero/clear it after the TUR without hurting anything.

-- Patrick Mansfield
