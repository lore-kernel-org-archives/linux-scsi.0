From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Trivial patch for scsi logging text string
Date: 15 Apr 2003 16:42:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050442929.2571.31.camel@mulgrave>
References: <Pine.LNX.4.44L0.0304151524010.699-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:25094 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264099AbTDOVaw (for <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2003 17:30:52 -0400
In-Reply-To: <Pine.LNX.4.44L0.0304151524010.699-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-04-15 at 14:31, Alan Stern wrote:
> On 15 Apr 2003, James Bottomley wrote:
> 
> > On Tue, 2003-04-15 at 12:03, Greg KH wrote:
> > > Hm, I don't think I can submit scsi patches to Linus :)
> > > Why not send them to the scsi maintainers...
> > 
> > The SCSI maintainers are linux-scsi@vger.kernel.org, so we've already
> > been copied on this one.
> > 
> > James
> 
> Does that mean that linux-scsi will forward my patch to Linus?  I hope so,
> because I've got another one to submit (to Marcelo), more substantive this
> time.

Yes, for 2.5

> In 2.4.21-pre7, when the scsi error-handler decides that it has cleaned 
> things up and retries the original command, it neglects to zero out the 
> command's sense buffer first.  In all likelihood the sense buffer will 
> contain old data left over from the error recovery operations.  This 
> confuses scan_scsis(), which thinks that because there is valid sense data 
> its INQUIRY probe must have failed.  This patch clears the sense buffer 
> before a retry.
> 
> If nobody on the linux-scsi list objects to it, this patch should be 
> applied.

2.4 is more tricky.  Since fixing 2.5 is pretty much a full time job,
there's no-one really who looks after SCSI in 2.4.  It's probably best
to send it to Marcelo along with an explanation of what the problem is.

James


