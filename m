From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] SCSI tape fixes (new version): sense descriptor
	init, bsf->weof, blkno, debugging
Date: Tue, 15 Mar 2005 12:14:27 -0600
Message-ID: <1110910469.5685.19.camel@mulgrave>
References: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:59589 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261741AbVCOSOs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 13:14:48 -0500
In-Reply-To: <Pine.LNX.4.61.0503121903010.6875@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-03-12 at 19:04 +0200, Kai Makisara wrote:
> This is an updated version of the patch I sent March 7. The sense descriptor
> initialization has been made lighter.
> 
> The patch at the end of this message applies to 2.6.11-bk7 + st descriptor sense
> patch + st auto eof patch (i.e., st patches currently in scsi-misc-2.6). The
> patch fixes the following problems:

I'm afraid this doesn't apply.  It looks like I've got an interim patch
that's crept in somewhere in the tree.

Could you take a look at scsi-misc-2.6 (or the patches on www.parisc-
linux/~jejb/scsi_diffs) and see if you can construct a diff between
where I currently am and where I should be?

Thanks,

James


