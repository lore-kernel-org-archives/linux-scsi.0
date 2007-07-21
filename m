From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/4] more gdth patches for your amusement
Date: Sat, 21 Jul 2007 16:34:10 -0400
Message-ID: <20070721203410.GA1004@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:54053 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760707AbXGUUeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:34:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>


This is the rest of the stuff checked into the 'gdth' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

As noted before, I'm fine with Christoph's gdth work superceding mine,
or whatever.  This was just me poking around.  Hopefully the patches
are useful for illustration, if nothing else.

1) [SCSI] gdth: kill gdth_{read,write}[bwl] wrappers
2) [SCSI] gdth: Move probe-time error handling code to end of each function
3) [SCSI] gdth: make some virt ctrlr code common; shuffle SHT members
4) [SCSI] gdth: convert to modern SCSI host alloc/scan

