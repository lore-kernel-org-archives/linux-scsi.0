From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 18 Jan 2004 09:35:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074436541.1756.8.camel@mulgrave>
References: <1074382860.1756.20.camel@mulgrave>
	<20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
	<20040118062157.GA11083@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:47781 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261774AbUAROfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 09:35:48 -0500
In-Reply-To: <20040118062157.GA11083@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-01-18 at 01:21, Andrew Vasquez wrote:
> That NVRAM setting really has no functional meaning for the card or
> Linux driver.  I believe it was an artifact from some ancient
> (non-linux) driver.  In essence, the ha flag simply indicates the
> which type of IOCBs are used to initiate the CDB transfer.

Well, since there are still no published specs, I had to guess...

> Here's a small patch, not sure if its going to solve your problem
> though.  I'll look some more tomorrow.

I tried the patch, but the behaviour is still the same.

What I see is that the returned data from actual data transfer
instructions is full of NULLs (presumably either because there was no
transfer, or the transfer was to the wrong location---although the fact
that the IOMMU doesn't halt the machine does tend to deny the latter).

I'm also using a qla1280 (not a 12160) if that helps.

James


