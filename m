From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: Fw: [Bugme-new] [Bug 3787] New: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
Date: Sun, 21 Nov 2004 21:55:14 +0100
Message-ID: <200411212155.14577.chrivers@iversen-net.dk>
References: <20041121123832.3afab90f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:59953 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S261775AbUKUUzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 15:55:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id DB61CA8508
	for <linux-scsi@vger.kernel.org>; Sun, 21 Nov 2004 21:55:19 +0100 (CET)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 12799-06 for <linux-scsi@vger.kernel.org>;
	Sun, 21 Nov 2004 21:55:15 +0100 (CET)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Sun, 21 Nov 2004 21:55:15 +0100 (CET)
In-Reply-To: <20041121123832.3afab90f.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Sunday 21 November 2004 21:38, Andrew Morton wrote:
> Begin forwarded message:

Andrew, please look at http://bugme.osdl.org/show_bug.cgi?id=3761. I reported 
the same bug, and have some comments from the SCSI people. James Bottomley 
helped me a lot, and has the patch that supposedly fixes it (I haven't had a 
chance to try it yet). The patch that is included in my bug report worked 
well for me as far as I couldn't reproduce a crash anymore. Unfortunately, 
because of the USB subsystem is broken in 2.6.10-rc* it's no good for my 
server. (I'm still using 2.6.5.)

That's on vanilla kernels, but I'm going to see if -mm is better, soon.

-- 
Regards,
Christian Iversen
