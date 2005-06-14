From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Sym53c8xx_2 Odd Byte Data Transfer patches
Date: Tue, 14 Jun 2005 21:50:41 +0100
Message-ID: <20050614205041.GB11655@parcelfarce.linux.theplanet.co.uk>
References: <91888D455306F94EBD4D168954A9457C013519A0@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13799 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261331AbVFNUtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 16:49:36 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C013519A0@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephens, Larry" <larry.stephens@lsil.com>
Cc: "Linux-Scsi@Vger. Kernel. Org (E-mail)" <linux-scsi@vger.kernel.org>

On Mon, May 09, 2005 at 06:16:48AM -0600, Stephens, Larry wrote:
> > These changes fix a problem with odd byte data transfers to a wide device
> > (16 bits) in the LSI sym53c8xx_2 driver.  This issue is primarily seen
> > only with tape drives although the code doesn't restrict the fix to any
> > particular device.

While this patch does seem to solve the problem of transferring an odd
number of bytes to the device, I recently received a bug report saying
that we don't accept an odd number of bytes transferred from a device.
It seems to me that it's going to require modifying the scsi scripts in
order to do this.  Do you agree?  Have you looked into transfers in the
opposite direction as part of this work?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
