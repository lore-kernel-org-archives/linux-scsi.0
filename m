From: Burn Alting <burn@goldweb.com.au>
Subject: sd_remove() called on a tape device - Linux 2.6.8.1 kernel
Date: Thu, 26 Aug 2004 14:32:11 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093494731.3549.117.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from GOL139579-1.gw.connect.com.au ([203.63.118.157]:9421 "EHLO
	goldweb.com.au") by vger.kernel.org with ESMTP id S267460AbUHZEcQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 00:32:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by goldweb.com.au (Postfix) with ESMTP id 6C69E8E03CB
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2004 14:32:14 +1000 (EST)
Received: from goldweb.com.au ([127.0.0.1])
	by localhost (kermit [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09623-03 for <linux-scsi@vger.kernel.org>;
	Thu, 26 Aug 2004 14:32:12 +1000 (EST)
Received: from [192.168.1.100] (dsl-180.192.240.220.lns02-nort-cbr.dsl.comindico.com.au [220.240.192.180])
	by goldweb.com.au (Postfix) with ESMTP id 6A5A18E033C
	for <linux-scsi@vger.kernel.org>; Thu, 26 Aug 2004 14:32:10 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

I'm running Fedora Core 2 with a ftp.kernel.org 2.6.8.1 kernel.

I've noticed that for some reason, when I reboot the system, it sends a
SCSI Synchronize Cache command to a tape device I have attached to the
system. This occurs at the end of the shutdown process just before doing
a reset into the BIOS (or whatever).

The tape is at LUN 0 and a disk is at LUN 7, the only scsi devices on
this system (hanging off an LSI Logic FC controller). The main disk is
an IDE.

Is there anything I can do to further track this down? I know that for
some reason the sd_remove() routine is being called rather than
st_remove() - but not sure why. The system recognises the tape quite
happily and reads/writes to it, so it knows what's at that scsi bus
location.

Regards
Burn Alting

