From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] add SMP passthrough support via bsg
Date: Mon, 09 Jul 2007 12:57:42 +0900
Message-ID: <20070709125742V.fujita.tomonori@lab.ntt.co.jp>
References: <20070709125203F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55423 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXGIEDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 00:03:47 -0400
In-Reply-To: <20070709125203F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, dougg@torque.net, Eric.Moore@lsi.com, jens.axboe@oracle.com

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] add SMP passthrough support via bsg
Date: Mon, 09 Jul 2007 12:52:03 +0900

> This is an updated version of the patchset to add SMP passthrough
> support via bsg:
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06350.html
> 
> - I added mptsas support
> 
> - I updated the patch for libsas to use the new block-layer bidi
> support (the previous version uses sense buffer for bidi hacky). The
> change is trivial.
> 
> This patchset can be applied cleanly to scsi-misc and the latest
> Linus' tree (2.6.23) however it depends on bsg and the block-layer
> bidi patcheset.
> 
> I setup a tree based on 2.6.23 including bsg, the block-layer bidi,
> and this patchest:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git smp

BTW, the block-layer bidi refers to the following patchset:

http://marc.info/?l=linux-scsi&m=118131577828493&w=2
