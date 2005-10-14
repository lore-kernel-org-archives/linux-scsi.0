From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: mpt fusion driver performance issue in 2.6.14-rc2
Date: Thu, 13 Oct 2005 18:07:35 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0474768A@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18568 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932108AbVJNAHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 20:07:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, linux-scsi@vger.kernel.org
Cc: "Brauer, Jonathan" <Jonathan.Brauer@lsil.com>, Roy Wade <roy.wade@lsil.com>, "Pope, Steve" <spope@lsil.com>, "Maloy, Joe" <Joe.Maloy@lsil.com>, "Unrein, Jason" <jason.unrein@lsil.com>

On Wednesday, October 12, 2005 3:05 PM, Chen, Kenneth W wrote:
> 
> Moore, Eric Dean wrote on Wednesday, October 12, 2005 1:58 PM
> > There have been several post circulating about the "release failed"
> > issue.  I thought I saw an email recently from someone at Intel
> > that had root caused the problem. I'm been trying to find 
> that all day
> > to find that email. I believe it was on this or the linux-kernel
> > forums.  Had you seen it?
> 
> Are you referring to this thread:
> http://marc.theaimsgroup.com/?t=112802043200007&r=1&w=2
> 
> If it is, then it was me originally posted the patch.
> 

Sorry, I remember that email, but forgot that was you.
It's been a very a busy time at the office.

Thanks for your detailed info before, as it makes sense why
dv would fail for ioc0, when ioc1 is brought up. Thanks for that
detail description. I'm not sure whether its good idea
to goto sleep from the mpt_get_msg_frame(). I will have to check
the code to insure interrupts are not disabled when this
is called.  I almost prefer going to sleep from 
mptscish_do_cmd() function which occurs during DV when
interrupts are enabled, and we probably have the info
knowing whether the ioc's are in reset stage. 

Part of my problem is I'm not able to reproduce this issue here in
my office. We can take this offline between our FAE, John Brauer, 
which I copied on this email.  He is in Portland area, and if 
your there, perhaps he can drop by your office.

Eric Moore
LSI Logic




