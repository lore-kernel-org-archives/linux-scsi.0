From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/3] Is it time for varlen extended and vendor-specific
 cdbs
Date: Thu, 03 Apr 2008 19:07:15 +0300
Message-ID: <47F500B3.30104@panasas.com>
References: <47E92672.1040208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33614 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYDCQJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 12:09:48 -0400
In-Reply-To: <47E92672.1040208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Submitted is a patchset for adding support for variable-length, extended,
> and vendor specific CDBs. It should now cover the entire range of the 
> SCSI standard. (and/or any other use of command packets in block devices)
> 
> They are based on scsi-misc/scsi-rc-fixes/linux-block. They are aimed
> for the 2.6.26 merge window. Andrew please also include them in -mm
> for testing.
> 
ping James.

Are you giving me the other side of the boot on these patches?
Is that NO for Linux-next or NACK for never?

If it is a maybe. Could you please acknowledge a "maybe, need testing"
so they can be tested in -mm tree. A new -mm tree has passed after
I sent these patches and they are still not tested there.

ping Jens.
I need your ACK on the block bits of these patches. (patch 2/3).
There are already users that might use this facility if available.

Andrew Hi?
Could we test these patches anyway. It is a new fixture for
supporting more of the scsi standard. And a way for vendor specific
commands to any scsi/block device in a common way. Today every
driver/vendor cooks it's own char device and private ioctrls to issue
such commands. With these patches and a patch to the bsg driver that
are already used more then a year, these things could be done in one
standard way. Including very efficient way to pass large chunks of
data. The new fixture is not dangerous at all, only the first patch
is a cleanup and optimization which might be dangerous (theoretically),
hence the request for testing. I did it this way so the overall cost
of the enhancement is zero, or actually we gain a few bytes and a couple
of cycles.

These 3 patches are on a git here:
git://git.open-osd.org/open-osd.git varlen

And on the gitweb here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=varlen

They will be rebased from time to time ontop of latest scsi-misc/scsi-rc-fixes

Boaz
