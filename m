From: "Smith, Gerry" <Gerrys@lsil.com>
Subject: RE: MegaRAID 511 i4 IDE
Date: Thu, 8 Sep 2005 08:57:13 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5706E99C76@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55021 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932503AbVIHM5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 08:57:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kenneth Porter <shiva@sewingwitch.com>, Linux SCSI <linux-scsi@vger.kernel.org>

> Is there any hope that just adding the entry to the PCI 
table would make this work? Or would the 511 need special-case code?

The 511 should work just fine.  It looks just like a MegaRAID SCSI
controller.

Gerry


-----Original Message-----
From: Kenneth Porter [mailto:shiva@sewingwitch.com] 
Sent: Thursday, September 08, 2005 5:07 AM
To: Linux SCSI
Subject: MegaRAID 511 i4 IDE

Alas, I've got one of these critters, and I don't see it listed in 
megaraid_mbox.c. (The subsystem device is 0x0511.) The I4_133 (0x0522) is 
listed, though. Is there any hope that just adding the entry to the PCI 
table would make this work? Or would the 511 need special-case code?

<http://www.lsilogic.com/products/megaraid/megaraid_i4.html>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
