From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Feral Qlogic ISP driver up for testing
Date: 15 May 2003 11:58:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053017923.2267.76.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:32516 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264102AbTEOQqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 12:46:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@digeo.com>, mjacob@feral.com

I've taken Matthew Jacob's latest drop of the Feral ISP driver and put
it up under bitkeeper at

http://linux-scsi.bkbits.net/scsi-isp-2.5

I've plumbed it into the SCSI build and done some minor tweaking to make
it compile and run correctly in 2.5 (a missing vmalloc #include and the
irqreturn_t stuff).

If people could check it out, I'd be grateful.

I find on my 1280 board that it panics in isp_reset(), but that could
just be because I use exotic hardware (a PA-RISC C360 box) for testing.

James


