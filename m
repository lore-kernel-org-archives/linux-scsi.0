From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Tue, 6 Jul 2010 16:04:06 +0900
Message-ID: <20100706160349L.fujita.tomonori@lab.ntt.co.jp>
References: <20100702110343.GA27159@lst.de>
	<20100705160023S.fujita.tomonori@lab.ntt.co.jp>
	<20100705192413.GA24189@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34642 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab0GFHEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 03:04:32 -0400
In-Reply-To: <20100705192413.GA24189@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org

On Mon, 5 Jul 2010 21:24:13 +0200
Christoph Hellwig <hch@lst.de> wrote:

> > Wired, I've just got Intel SSD X25-M drives and mkfs.xfs worked well.
> 
> What codebase were you testing on?  Sorry, but curently I'm a bit lost
> in the maze of patches.  I've got both and intel and an OCZ SSD (right
> now I'm travelling with only access to the OCZ actually) and I'd like
> to test the latest variant again.

I tested:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git discard


I rebased the changes against Jens' for-2.6.36 and I've just sent the
latest patch.
