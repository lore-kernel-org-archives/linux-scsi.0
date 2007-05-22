From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Wed, 23 May 2007 08:32:01 +0900
Message-ID: <20070523083201E.fujita.tomonori@lab.ntt.co.jp>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
	<20070512153023.GA8088@infradead.org>
	<200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:36957 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbXEVXcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 19:32:13 -0400
In-Reply-To: <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Mon, 14 May 2007 23:40:03 +0900

> From: Christoph Hellwig <hch@infradead.org>
> Subject: Re: [PATCH 0/19] clean ups on the drivers
> Date: Sat, 12 May 2007 16:30:23 +0100
> 
> > On Sat, May 12, 2007 at 07:05:42PM +0900, FUJITA Tomonori wrote:
> > > There are two patches for each driver, removing the non-use-sg code
> > > and converting to use the accessors.
> > 
> > One patch would probably be fine aswell.
> 
> I merged the two. And I finished cleaning up 35 drivers in total.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups

I rebased the cleanup patchset against the latest scsi-misc
(352e921f0dd42f79652cdb50dd91122d068d7209). It includes the cleanups
for more than 40 drivers.
