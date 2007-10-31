From: ian <spyro@f2s.com>
Subject: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 31 Oct 2007 21:03:24 +0000
Message-ID: <1193864605.25899.253.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outmail1.freedom2surf.net ([194.106.33.237]:45896 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbXJaVgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 17:36:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

Hi folks.

Please CC me - I am NOT on LKML at present

There was a recent patch to remove the coherent memory interface from
the DMA API.

I'd like to ask that this not happen - there are several users of this
code in the handhelds.org tree, which we hope will merge into mainline.
this code is _essential_ to allow support of these devices.

Removing this from mainline will only increase the hh.org delta which we
are working hard to reduce, and there is no other realistic way to
support these devices.

Thanks,

Ian

