From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sun, 09 Oct 2005 12:28:00 -0400
Message-ID: <43494510.6080706@adaptec.com>
References: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>	 <1127094214.4847.54.camel@mulgrave>  <4346F483.8040704@adaptec.com> <1128781870.4824.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:20366 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750888AbVJIQ2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2005 12:28:03 -0400
In-Reply-To: <1128781870.4824.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On 10/08/05 10:31, James Bottomley wrote:
> On Fri, 2005-10-07 at 18:19 -0400, Luben Tuikov wrote: 
> 
>>Did this patch make it in?
> 
> 
> Yes, it did ... it should be present in git head.

Thank you.

>>After the transition to kthread_*, "rmmod aic94xx" hangs at
>>"kthread_stop", judging from /proc/<pid>/wchan.
> 
> 
> Try doing an alt-sysrq-t to see the stack trace for both the rmmod
> process and the relevant error handler thread ... that should at least
> say where it is stuck.

I'll take a look if it is still getting stuck.

-- 
http://linux.adaptec.com/sas/
Disclaimer: Opinions stated in this email are my own, not of my employer.
For inquiries write to: luben_tuikov@adaptec.com or ltuikov@yahoo.com.
