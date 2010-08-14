From: Stefan Schmitt <development.stefan@alice.de>
Subject: Interest in a driver for PCMCIA Bus toaster (New Media) with advansys chip set?
Date: Sat, 14 Aug 2010 19:34:05 +0200
Message-ID: <201008141934.05664.development.stefan@alice.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:48989 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0HNRtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 13:49:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo,

the card is labelled PS: 404-15-02A. As much as I could see, there
is no linux driver available.

        Product Name:   PCMCIA Bus Toaster SCSI Adapter
        Identification: manf_id: 0x10cd card_id: 0x0001
                 function: 8 (SCSI)
                 prod_id(1): "PCMCIA Bus Toaster" (0x590031a6)
                 prod_id(2): "SCSI Adapter" (0x96269fcd)

I have an initial version of driver code (for the 2.6 kernel). I could send 
the code to someone more experienced if there is interest.

Cheers,
Stefan
