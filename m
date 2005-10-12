From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: mpt fusion driver performance issue in 2.6.14-rc2
Date: Wed, 12 Oct 2005 14:05:09 -0700
Message-ID: <200510122105.j9CL5Vg29053@unix-os.sc.intel.com>
References: <91888D455306F94EBD4D168954A9457C04746B82@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:50820 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S1751579AbVJLVFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 17:05:33 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C04746B82@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Moore, Eric Dean'" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

Moore, Eric Dean wrote on Wednesday, October 12, 2005 1:58 PM
> There have been several post circulating about the "release failed"
> issue.  I thought I saw an email recently from someone at Intel
> that had root caused the problem. I'm been trying to find that all day
> to find that email. I believe it was on this or the linux-kernel
> forums.  Had you seen it?

Are you referring to this thread:
http://marc.theaimsgroup.com/?t=112802043200007&r=1&w=2

If it is, then it was me originally posted the patch.


> Anyways the plan is to eventually go to SPI transport. Have you seen
> this post by James?
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112879629201766&w=2
> 
> I have it on my todo list, and plan to review this SPI updates 
> sometime this week.  Perhaps you can try this patch out and let us
> (and James) whether its solved.

I suppose I can just run that patch through our benchmark setup.

- Ken

