From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: mpt fusion driver performance issue in 2.6.14-rc2
Date: Wed, 12 Oct 2005 14:57:53 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C04746B82@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:20448 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751567AbVJLU56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 16:57:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Thursday, September 29, 2005 12:59 PM, Chen, Kenneth W wrote:  

> 
> Something happened in between kernel 2.6.12 and 2.6.14-rc2, where
> disk performance went 20X slower on the latest release kernel. I
> suspect it has something to do with the fusion driver. This showed
> up in the boot log: "mptscsih: ioc0: DV: Release failed." is it
> significant?
> 
> 

There have been several post circulating about the "release failed"
issue.  I thought I saw an email recently from someone at Intel
that had root caused the problem. I'm been trying to find that all day
to find that email. I believe it was on this or the linux-kernel
forums.  Had you seen it?  We need to root cause that, however 
I'm very much burried in SAS.

Anyways the plan is to eventually go to SPI transport. Have you seen
this post by James?
http://marc.theaimsgroup.com/?l=linux-scsi&m=112879629201766&w=2

I have it on my todo list, and plan to review this SPI updates 
sometime this week.  Perhaps you can try this patch out and let us
(and James) whether its solved.

Eric Moore 
