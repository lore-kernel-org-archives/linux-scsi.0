From: David Zeuthen <david@fubar.dk>
Subject: scsi_mod and device binding
Date: Mon, 05 Jul 2004 19:20:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089048048.12073.32.camel@ixus.fubar.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port488.ds1-ly.adsl.cybercity.dk ([212.242.145.51]:47149 "EHLO
	tux.fubar.dk") by vger.kernel.org with ESMTP id S266022AbUGERVp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2004 13:21:45 -0400
Received: from [10.0.0.10] (ixus.fubar.dk [10.0.0.10])
	by tux.fubar.dk (Postfix) with ESMTP id 12960533CA
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jul 2004 19:34:27 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I have a question regarding the scsi_mod module. Basically, I'm quite
interested in using one of those 6in1 card readers without having
CONFIG_SCSI_MULTI_LUN=y in my kernel configuration. 

So, I understand that this can be achieved by using the max_luns option
when doing modprobe scsi_mod or adding the appropriate SCSI id in the
whitelist inside the kernel. But what if this module is already loaded
because I earlier plugged in my external harddisk enclosure using USB2?

In general, I think what I'm asking for is some kind of functionality to
specifically bind a given driver/kernel module with device-specific
options to a specific device. From user space. Are there any plans for
this in the 2.6 timeframe?

Thanks,
David


