From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata driver update posted
Date: Thu, 17 Jul 2003 17:14:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1711C8.6040207@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20390 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271058AbTGQVAG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 17:00:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>

Just updated libata library and associated ata_piix driver with several 
bug fixes and internal improvements.  It now works in 2.6 (again).

Next update will add several host drivers, now that the libata API is 
settling down.


2.4.21-based patch:
ftp://ftp.??.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.4/2.4.21-libata4.patch.bz2

2.4.21-based BitKeeper repo:
bk://kernel.bkbits.net/jgarzik/atascsi-2.4

2.6.0-test1-based patch:
ftp://ftp.??.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.6/2.6.0-test1-libata1.patch.bz2

2.6.0-test1-based BitKeeper repo:
bk://kernel.bkbits.net/jgarzik/atascsi-2.5
(yes, "2.5" is not a typo, I haven't changed the name to 2.6 yet)


Remove the ".??" if the file has not appeared on your favorite 
kernel.org mirror yet.


Changes:
* beginnings of pluggable timing configuration
* beginnings of cable detection
* much improved ATA device probing
* a bunch of internal improvements and cleanups (too many to list)
* additional of DocBook documentation
* many bug fixes

