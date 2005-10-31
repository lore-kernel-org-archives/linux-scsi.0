From: Mark Haverkamp <markh@osdl.org>
Subject: Re: Latest update to scsi-misc-2.6
Date: Mon, 31 Oct 2005 09:36:19 -0800
Message-ID: <1130780179.24530.21.camel@markh1.pdx.osdl.net>
References: <1130778840.24530.20.camel@markh1.pdx.osdl.net>
	 <1130779948.3293.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19181 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750981AbVJaRgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:36:21 -0500
In-Reply-To: <1130779948.3293.35.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-10-31 at 11:32 -0600, James Bottomley wrote:
> On Mon, 2005-10-31 at 09:13 -0800, Mark Haverkamp wrote:
> > I updated my local scsi-misc-2.6 tree today and had merge conflicts
> > somehow.  The tree had not been previously locally modified and was up
> > to date as of last week.  I used the cg-update command to perform the
> > update.  After receiving the changes it got a merge conflict:
> > 
> > Applying changes...
> > Merging fe607aa94f5d25ee84f9a9a4fdf2cce3765e12e4 -> d078650986b117520f2b10cb72c04bc1904e3ba7
> >         to a25bbd9e2f6c6907672301fe934a8f9989e60330...
> > ... Auto-merging drivers/scsi/scsi_scan.c
> > merge: warning: conflicts during merge
> 
> My best guess is that your merge programme is confused.  I've had to
> merge the tree up several times to fix conflicts, but it's the same
> tree.  It looks like whatever tool you used to merge failed to recognise
> this.

OK, Thanks,  Maybe I need to update my git tools.

Mark.


> 
> James
> 
-- 
Mark Haverkamp <markh@osdl.org>

