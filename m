From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: SMART support for SATA drives in SAS enclosures
Date: Mon, 14 May 2007 17:58:09 +0200
Message-ID: <46488711.9020903@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2507 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXENQDc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 12:03:32 -0400
Received: from rousseau.macroscoop.nl (rousseau.macroscoop.nl [IPv6:2001:888:1734:0:214:5eff:fe2a:6a7a])
	by mondriaan.macroscoop.nl (envelope-from P.Zandbergen@macroscoop.nl) (8.13.8/8.13.8) with ESMTP id l4EFwAIs027103
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 17:58:10 +0200
Received: from [82.94.9.131] (botero.macroscoop.nl [82.94.9.131])
	by rousseau.macroscoop.nl (envelope-from P.Zandbergen@macroscoop.nl) (8.13.8/8.13.8) with ESMTP id l4EFwARI027372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 17:58:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is SMART support available for SATA drives in SAS enclosures?

I'm testing this setup

LSI Logic SAS3800X PCI-X SAS controller (mptsas driver)
Promise V-Trak J300S SAS/SATA enclosure/expander
12x Seagate ST3500630NS
Linux kernel 2.6.21.1 x86_64
smartmontools-5.37-1.1.fc6 from Fedora Core 6

"smartctl -i -d sat /dev/sdc" gives me

Smartctl: Device Read Identity Failed

Same with "-d ata".

If I treat the disk as SCSI ("-d scsi"), the command
will not fail, but wil only retrieve the serial number.

Thanks,
Pim

