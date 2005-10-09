From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sun, 09 Oct 2005 10:02:57 +1000
Message-ID: <43485E31.1040906@torque.net>
References: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>	 <1127094214.4847.54.camel@mulgrave>  <4346F483.8040704@adaptec.com> <1128781870.4824.15.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:14000 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932189AbVJIACP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2005 20:02:15 -0400
In-Reply-To: <1128781870.4824.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2005-10-07 at 18:19 -0400, Luben Tuikov wrote: 
> 
>>Did this patch make it in?
> 
> 
> Yes, it did ... it should be present in git head.
> 
> 
>>After the transition to kthread_*, "rmmod aic94xx" hangs at
>>"kthread_stop", judging from /proc/<pid>/wchan.

In lk 2.6.14-rc2 "rmmod scsi_debug" got stuck in the
same spot. It works ok in lk 2.6.14-rc3

Doug Gilbert

