From: Matthew Wilcox <willy@debian.org>
Subject: Re: DPC vs tasklet
Date: Fri, 21 May 2004 01:39:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040521003939.GC6484@parcelfarce.linux.theplanet.co.uk>
References: <40ACE612.8020800@pobox.com> <OFD20B05A9.954B29CD-ON85256E9B.0002C560-88256E9B.000355CC@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:35517 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265291AbUEUAjm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 20:39:42 -0400
Content-Disposition: inline
In-Reply-To: <OFD20B05A9.954B29CD-ON85256E9B.0002C560-88256E9B.000355CC@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, May 20, 2004 at 05:36:27PM -0700, Bryan Henderson wrote:
> > Some
> > of the LINUX documentation I've read states "tasklets are the preferred
> > mechanism with which to implement your bottom half for a normal hardware
> > device".
> 
> In all the great answers about why other things are better than tasklets, 
> the basic question of why this documentation doesn't agree isn't 
> addressed.  Let me try:  I believe the context of this statement is a 
> comparison to the more traditional Unix method of implementing the bottom 
> half in the interrupt handler.  The statement is saying that a tasklet is 
> normally preferred to putting the same processing right in the interrupt 
> handler.

Actually, I think the quote in context probably refers to choosing
between using an old-style (now extinct) bottom half, a tasklet or
a softirq for doing the work that can't be done in the hardirq context.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
