From: Martin Diehl <lists@mdiehl.de>
Subject: How to clear bogus WP bit?
Date: Fri, 4 Mar 2005 17:06:54 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0503041647420.25272-100000@notebook.home.mdiehl.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from bart.webpack.hosteurope.de ([217.115.142.76]:23173 "EHLO
	bart.webpack.hosteurope.de") by vger.kernel.org with ESMTP
	id S262933AbVCDQEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 11:04:25 -0500
Received: from notebook.home.mdiehl.de (localhost.localdomain [127.0.0.1])
	by notebook.home.mdiehl.de (8.12.1/8.12.1) with ESMTP id j24G6uji027852
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 17:06:56 +0100
Received: from localhost (martin@localhost)
	by notebook.home.mdiehl.de (8.12.1/8.12.1/Submit) with ESMTP id j24G6tfI027849
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 17:06:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

my MMC flashcard used to work with my usb card reader right until a 
boot-crash of an embedded system while the card was in use there. Since 
then, both Linux and Windows report the card being write-protected. 
Reading still works without problems.

Note, on MMC-Cards there is no write-protect clip so I have no idea how it 
happened to become write protected and - even more important - how to 
unprotect it. I've already cheated the sd-driver to ignore the WP-bit so I 
can rw-mount again. However, when trying to write to the guy it returns 
command errors due to media protection still effective. So my current 
conclusion is somehow the MMC really managed to get into a write-protected 
state without any mechanical switch.

Any hints how to unprotect it? Is it possible somehow to clear the WP 
state by software? Or does this probably mean the MMC went south?

TIA
Martin

