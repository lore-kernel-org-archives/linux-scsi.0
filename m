From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: be2iscsi driver
Date: Tue, 08 Sep 2009 14:18:47 +0000
Message-ID: <1252419527.3990.39.camel@mulgrave.site>
References: <20090908083546.GA19467@serverengines.com>
	 <20090908200604.beb14288.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZIHOSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 10:18:52 -0400
In-Reply-To: <20090908200604.beb14288.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Tue, 2009-09-08 at 20:06 +1000, Stephen Rothwell wrote:
> Hi Jayamohan,
> 
> On Tue, 8 Sep 2009 14:05:58 +0530 Jayamohan Kallickal <jayamohank@serverengines.com> wrote:
> >
> >    This patch contains  a fix for powerpc compile issue  and has
> >     been tested for compile on powerpc with allyesconfig option.	
> 
> Thanks for that.
> 
> >   The series of  patches are described below:
> 
> This series should be applied in an order that allows the kernel as a
> whole to keep building at each step.  The easiest way to guarantee that
> would be to put your patch 1 as the last one.

Actually, I just folded these patches in to one last time.  For new
drivers, it really makes no sense to apply anything other than all in
one go.

However, for code inspection purposes, this is pretty useless.  The fix
is buried somewhere in several thousand lines of code.

Jayamohan, could you please just send a patch for what's currently in
the tree that fixes the issue, so we can better verify by inspection
that it's correct?  I'll fold it into the driver submit, so there won't
be any point in the tree where there's a ppc build breakage, but I would
like to see what the fix is without having to rebuild this patch and run
interdiff.

Thanks,

James


