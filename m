From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [patch] 2.6.10-rc1: SCSI aacraid warning
Date: Fri, 29 Oct 2004 08:13:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1099062782.13961.5.camel@markh1.pdx.osdl.net>
References: <Pine.LNX.4.58.0410221431180.2101@ppc970.osdl.org>
	 <20041029143712.GM6677@stusta.de>
	 <1099061134.13961.2.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:49841 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S263344AbUJ2PQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 11:16:16 -0400
In-Reply-To: <1099061134.13961.2.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2004-10-29 at 07:45 -0700, Mark Haverkamp wrote:
> On Fri, 2004-10-29 at 16:37 +0200, Adrian Bunk wrote:
> > On Fri, Oct 22, 2004 at 03:05:13PM -0700, Linus Torvalds wrote:
> > >...
> > > Summary of changes from v2.6.9 to v2.6.10-rc1
> > > ============================================
> > >...
> > > Mark Haverkamp:
> > >...
> > >   o aacraid: dynamic dev update
> > >...
> > 
> > 
> > This causes the following warning with a recent gcc:
> > 
[ ... ]
> Sorry about that, I have it fixed in my working version.  I must have
> forgotten to add it to the patch.


Actually looking back,  I did fix this in a recent patch that 
I sent to James titled

"[PATCH] 2.6.9 aacraid: Support ROMB RAID/SCSI mode" on October 21.

Mark.


-- 
Mark Haverkamp <markh@osdl.org>

