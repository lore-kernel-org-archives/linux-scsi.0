From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] Have qla2xxx driver bind fcports.
Date: Mon, 19 Jan 2004 13:49:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119134944.515440b0.akpm@osdl.org>
References: <1074532278.1645.24.camel@mulgrave>
	<20040119214030.78010.qmail@web10408.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38887 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264927AbUASVti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:49:38 -0500
In-Reply-To: <20040119214030.78010.qmail@web10408.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Cc: James.Bottomley@steeleye.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

"Michael W. Shaffer" <mwshaffer@yahoo.com> wrote:
>
> > As far as the resync goes, I'd like to wait a while just to
> > see if any more bugs turn up in the ioctl/failover separation
> > piece ... it will be easier to debug if we have fewer changes,
> > so how does early 2.6.2 sound for this (depending, of course,
> > on when that actually is)?
> 
> Thanks to everyone for figuring this out so quickly. Should I
> assume that this fix will be merged into 2.6.1-mm5 or so, and
> eventually into 2.6.2? I'll probably continue to do some beta
> testing on this system with the patches I have now, but I
> would most likely wait until the LUN fix is into the -mm tree
> before trying to move into production with it.
> 

I added Andrew's patch to -mm.   I'll get -mm5 out today.

James is suggesting 2.6.3-pre for merging this patch.  That may be
conservative: we've only just started in on the post-2.6.1 work, so 2.6.2
is a while off yet.


