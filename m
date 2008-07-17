From: "Nicolas TUFFIER" <nicolas.tuffier@furyweb.org>
Subject: megaraid driver problem with st driver for LTO2 tape drive
Date: Thu, 17 Jul 2008 08:23:27 +0000
Message-ID: <fkNZHdHc.1216283007.1610810.nico@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:35361 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYGQIXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 04:23:30 -0400
Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 936E33EA10A
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 10:23:28 +0200 (CEST)
Received: from linux.bureau.home (www.furyweb.org [82.236.245.224])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 5767F3EA103
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 10:23:28 +0200 (CEST)
Received: from secure.furyweb.org (localhost [127.0.0.1])
	by linux.bureau.home (Postfix) with SMTP id 2A2703802
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 10:23:27 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Hardware configuration :
I have a PERC 4e/DC controller (PCI Express - fw:5A2D) plugged on an Asus
P5K (Core 2 E6400, 2GB dual channel) and an IBM LTO2 HH Tape drive
(fw:0330). I've upgraded firmwares from 520D for the PERC HBA and from
0290 for the tape drive.

Software configuration :
My system is a Debian etch (4.0) and have compiled a 2.6.25.9 kernel from
official source (kernel.org).

Problem description :
It seems that the st driver cannot handle variable block size and is
limited to 64k max fixed block size when tape is connected to the PERC
HBA.
The st driver print Block limits : 256 - 524288 when loaded and dd on the
tape with bs > 64k print device busy error.
In some situations (full system boot) loading st driver make system hang
(kernel panic), in single mode there's no problem with module loading.
However, there is no problem when tape drive is connected on a Tekram DC
390 U3W (sym53c8xx driver).

I can eventually do some tests and/or provide more info, let me know what
you need.
