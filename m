From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Mon, 14 May 2007 17:39:06 +0200
Message-ID: <4648829A.10602@s5r6.in-berlin.de>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>	<20070512153023.GA8088@infradead.org> <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:53167 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXENPkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 11:40:12 -0400
In-Reply-To: <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

FUJITA Tomonori wrote:
>> > There are two patches for each driver, removing the non-use-sg code
>> > and converting to use the accessors.
...
> I merged the two. And I finished cleaning up 35 drivers in total.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups

According to what I see via gitweb, at least usb-storage, ieee1394/sbp2,
and firewire/fw-sbp2 weren't treated yet.  If somebody does so for the
latter two:  The shost->shost_gendev.parent has to be changed for
scsi_dma_{un}map.  I don't know if this can be done without breaking
anything.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
