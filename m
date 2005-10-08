From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sat, 08 Oct 2005 09:31:10 -0500
Message-ID: <1128781870.4824.15.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>
	 <1127094214.4847.54.camel@mulgrave>  <4346F483.8040704@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36531 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932144AbVJHOdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Oct 2005 10:33:39 -0400
In-Reply-To: <4346F483.8040704@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-10-07 at 18:19 -0400, Luben Tuikov wrote: 
> Did this patch make it in?

Yes, it did ... it should be present in git head.

> After the transition to kthread_*, "rmmod aic94xx" hangs at
> "kthread_stop", judging from /proc/<pid>/wchan.

Try doing an alt-sysrq-t to see the stack trace for both the rmmod
process and the relevant error handler thread ... that should at least
say where it is stuck.

James


