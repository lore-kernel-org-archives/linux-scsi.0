From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Thu, 23 Dec 2004 18:36:20 -0600
Message-ID: <20041224003620.GA31981@cs.umn.edu>
References: <20041221223645.GA2736@cs.umn.edu> <1103828621.5290.42.camel@mulgrave> <20041223200153.GA18386@cs.umn.edu> <1103835435.5290.45.camel@mulgrave>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:5087 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261348AbULXAgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 19:36:41 -0500
Content-Disposition: inline
In-Reply-To: <1103835435.5290.45.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Dec 23, 2004 at 02:57:15PM -0600, James Bottomley wrote:
> On Thu, 2004-12-23 at 14:01 -0600, Dave C Boutcher wrote:
> > The patches I submitted on Tuesday are incremental on top of the four
> > patches from November 29th.  Let me know if you would like the
> > November 29th patches re-sent.
> 
> Actually, just the limit size of I/O requests with the two patches
> rolled together (or is there nothing left of this now?)

I'm not sure I parse that...but in any case, one of the four patches
from November limited the size of the I/O requests based on information
from the SCSI target, with a default value in case the target doesn't
tell us.  I got overly clever and made the default value a module
parameter. Jens pointed out that I was being redundant, since
there are other ways to set max sectors.  The patch I submitted
on Tuesday leaves the basic function intact (setting max I/O size
based on input from the target) and just removes the redundant module
parameter.

-- 
Dave Boutcher
