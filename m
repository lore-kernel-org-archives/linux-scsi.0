From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: potential initialisation problem in the aic94xx
Date: Mon, 28 Nov 2005 15:52:48 -0600
Message-ID: <1133214768.3325.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:17109 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751325AbVK1Vwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:52:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I'm not sure if this is a genuine problem, or I just happen to have a
broken card:  Since the card is unusual in being keyed 3.3v only, I
don't actually have any working x86 machine I can try it in.

The symptoms I see on my ia64 box are that as soon as the driver tries
to touch the Region 0 BAR via mmio, the system gives me a MCE.  This is
probably because the card fails to respond on this address and thus
gives some type of PCI bus timeout.  My suspicion is that the card
requires some firmware setup that the on-board BIOS does before the BARs
respond (and since this is an ia64 box, it doesn't run the BIOS).  Could
someone (i.e. Jeff) with access to the Docs have a look and see if this
suspicion can be verified (or someone with a card try it in an ia64 to
see if the same symptoms are observed)?

Thanks,

James


