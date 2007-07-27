From: Bjarne Thomsen <bjarne.b.thomsen@gmail.com>
Subject: AIC79XX PCI-X SCSI mystery
Date: Fri, 27 Jul 2007 09:57:10 +0200
Message-ID: <1185523030.7330.24.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:42387 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763207AbXG0H6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 03:58:02 -0400
Received: by ug-out-1314.google.com with SMTP id j3so669526ugf
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 00:58:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have a dual Opteron Tyan MB (S2885) with 4 PCI-X slots.
The 2 first slots can work up to 100 MHz, the last 2 up to 66 MHz.

I have 2 PCI-X Adaptec SCSI controllers: 29160 and 39320A.
A SCSI disk is connected to port A on the 39320A.

When I mount the 39320A in any of the 4 slots the system hangs
after a few seconds (with no error messages in syslog) when I
copy a directory with many files to the SCIS disk.

However, when I mount both controllers in either slots 1 and 2
or slots 3 and 4 I can copy 25GB of files without any hang-up.

I need some help to figure this out. It is a mystery to me.

2.6.22-2mdv #1 SMP Mon Jul 23 17:24:30 CEST 2007 x86_64 AMD Opteron(tm)
Processor 244 GNU/Linux

I do not wish to clutter this mail with random listings,
but I can supply output if somebody can tell me what is needed.

Bjarne Thomsen




