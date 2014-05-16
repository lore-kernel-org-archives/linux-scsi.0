From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: hyper-v storvsc switch up to SPC-3
Date: Fri, 16 May 2014 10:58:55 -0700
Message-ID: <1400263135.2221.58.camel@dabdike.int.hansenpartnership.com>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
		 <1400254748-21573-2-git-send-email-abbotti@mev.co.uk>
	 <1400260496.2221.44.camel@dabdike.int.hansenpartnership.com>
	 <53764D3F.3060008@mev.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45728 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757397AbaEPR66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2014 13:58:58 -0400
In-Reply-To: <53764D3F.3060008@mev.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, Andy Whitcroft <apw@canonical.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Tim Gardner <tim.gardner@canonical.com>

On Fri, 2014-05-16 at 18:39 +0100, Ian Abbott wrote:
> On 2014-05-16 18:14, James Bottomley wrote:
> > On Fri, 2014-05-16 at 16:39 +0100, Ian Abbott wrote:
> >> From: Andy Whitcroft <apw@canonical.com>
> >>
> >> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >
> > That is my patch, isn't it, just with a slightly modified comment:
> >
> > http://marc.info/?l=linux-scsi&m=137908428211951
> 
> I believe so, yes.  Looking at Ubuntu's kernel repository, Andy reverted 
> his original 4 patches and applied your patch instead.  I'm not sure 
> about the other patch (PATCH 2/2) that disables the MAINTENANCE_IN 
> command.  Perhaps that was needed as a consequence of claiming to be 
> SCSI level SPC-3?

Yes, see other email.

> > Andy promised to go off and test it and that's where the thread ended. I
> > take it the results of the testing was positive?  I was expecting him to
> > report back on that so KY could ack the patch.
> >
> > James
> 
> The patch seems to be in Ubuntu Saucy's 3.11 kernel version 3.11.0-12.18 
> onwards - see 
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-saucy.git;a=log;h=refs/tags/Ubuntu-3.11.0-12.18 
> for the logs.
> 
> Would you like me to resubmit the patch with you as the author?  There 
> isn't a "Signed-off-by:" line for you on this patch at the moment.  Is 
> it okay for me to add one?

I'm not really comfortable with the way these patches are being
submitted.  I really need Andy to justify what's been done and why, then
find an upstream acceptable format then for the Microsoft Hyper-V guys
to ack them.  We need more information than you can infer simply from
the patches being in Ubuntu.  If Andy's off somewhere, we can wait
because this is just simply feature enablement; the bug doesn't show
unless you enable trim on hv storvsc.

James


