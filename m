From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Patch status?
Date: Fri, 27 Oct 2006 15:45:24 -0500
Message-ID: <1161981924.3744.62.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0610271043270.6443-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36036 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752366AbWJ0UqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 16:46:17 -0400
In-Reply-To: <Pine.LNX.4.44L0.0610271043270.6443-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2006-10-27 at 10:45 -0400, Alan Stern wrote:
> James:
> 
> I haven't gotten any feedback about these two patch submissions, and they 
> aren't in the current scsi-misc GIT:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116059987422907&w=2

This one looks OK ... it's such a tiny micro optimisation, though.  I
think I just lost it along the way, sorry.

> http://marc.theaimsgroup.com/?l=linux-scsi&m=115947226830808&w=2

This one has warning phrases like "There are two potential weaknesses in
the patch.  One is that when the bad
sense data occurs, it unconditionally calls scsi_requeue_command().  Could
this lead to an infinite loop?"  which aren't conducive to immediate application.

I'll take a look at it when I get some time.

James


