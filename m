From: Matthias Prager <linux@matthiasprager.de>
Subject: JMicron JMB363 PCI SATA/IDE Card Support
Date: Wed, 19 Jun 2013 15:12:51 +0200
Message-ID: <51C1AE53.4030206@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:48545 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3FSNWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 09:22:39 -0400
Received: from [192.168.0.13] (p5DE449B4.dip0.t-ipconnect.de [93.228.73.180])
	by dd15408.kasserver.com (Postfix) with ESMTPSA id 0295394B060
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2013 15:12:55 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello everyone,

I'm having a hard time getting my JMicron JMB363 PCI SATA/IDE Card
to work under linux.
The 'lspci -nn' output reads as follows:
> RAID bus controller [0104]: JMicron Technology Corp. JMB363 SATA/IDE
> Controller [197b:2363] (rev 03)

I tried my own kernel (3.9.6) under gentoo with CONFIG_PATA_JMICRON and
CONFIG_SATA_AHCI enabled. And I tried using
the latest SystemrescueCD (with kernel 3.4.47) which has pretty much
everything compiled into it.

FreeBSD is recognizing the devices just fine. How do I get them
to run on linux?

- Matthias

P.S. a side note: this is in an virtualized environment (VMWare ESXi)
with pass-through.
