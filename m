From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: can all 53c7xx-related stuff be removed?
Date: Sat, 9 Feb 2008 11:54:43 -0500 (EST)
Message-ID: <alpine.LFD.1.00.0802091151440.5998@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:34967 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYBIQyw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 11:54:52 -0500
Received: from cpe001d60ad7267-cm001225dbafb6.cpe.net.cable.rogers.com ([99.236.100.208] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1JNsyW-0004bB-V5
	for linux-scsi@vger.kernel.org; Sat, 09 Feb 2008 11:54:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


  just an observation that, even though 53c7xx content has been
officially removed, there are still a few droppings hanging around the
tree:

$ grep -r 53c7xx *
arch/m68k/Makefile:# without -fno-strength-reduce the 53c7xx.c driver fails ;-(
Documentation/scsi/sym53c8xx_2.txt:by the 53c7xx and 53c8xx family.
Documentation/scsi/ncr53c8xx.txt:by the 53c7xx and 53c8xx family.
drivers/scsi/a4000t.c: * plus modifications of the 53c7xx.c driver to support the Amiga.
drivers/scsi/zalon.c: * Zalon 53c7xx device driver.
drivers/scsi/zorro7xx.c: * plus modifications of the 53c7xx.c driver to support the Amiga.
$

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
