From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Fri, 15 Jan 2010 12:02:43 -0800
Message-ID: <04391A4E90BB2149B010D22452FA16875F03445E@HQ-EXCH-6.corp.brocade.com>
References: <1259545058-4358-1-git-send-email-huangj@brocade.com>
	 <04391A4E90BB2149B010D22452FA16875EF12BFE@HQ-EXCH-6.corp.brocade.com>
 <1261095063.2752.34.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:28517 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0AOUCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 15:02:47 -0500
In-Reply-To: <1261095063.2752.34.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

Hi James,

I don't know if you haven been working on pulling this patch set into scsi-misc. If not, we would like to recall it. We understand that it doesn't conform to upstream patch submission standard, and we want to fix it. As you advised, we will make sure each patch is specific to one logic change in the resubmission.

We are also working on to cleanup the bfa driver. Our first effort is reducing the number of source files, and the goal is to reduce the file number to be on a par with most upstream drivers. 

I will resubmit 2.1.2.1 fix first, followed by driver cleanups starting with file number reduction. Please let me know if this plan works for you.

Thanks

Jing



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]
> Sent: Thursday, December 17, 2009 4:11 PM
> To: Jing Huang
> Cc: linux-scsi@vger.kernel.org; Adapter Linux Open SRC Team
> Subject: RE: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1
> (resubmit)
> 
> On Wed, 2009-12-16 at 19:55 -0800, Jing Huang wrote:
> > What is the status of this patch set? Is there anything I can do in
> > order to get it accepted in 2.6.33 merger window?
> 
> So, what actually happened is that it was submitted the day before the
> merge window opened, so I started to reply and then got swamped with
> merge window stabilisation work.
> 
> The reply was basically that the current split up still wasn't
> acceptable.  What I want to see is one well described patch per logical
> change.  What you actually did was split them up according to some
> arbitrary standard, so we got changes described as
> 
> bfa: bfa changes part 1
> 
> and
> 
> bfa: bfa changes part 2
> 
> So what I can do this once is accumulate all the change logs (which were
> better than the first time around) and do a single update for 2.6.33 on
> promise of better change sets in future.
> 
> Is that OK?
> 
> James
> 

