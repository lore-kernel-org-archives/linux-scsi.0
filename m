From: Karen Shaeffer <shaeffer@neuralscape.com>
Subject: MPT Fusion initialization in 2.6.23.12
Date: Fri, 11 Jan 2008 06:01:20 -0800
Message-ID: <20080111140120.GA2116@synapse.neuralscape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from synapse.neuralscape.com ([198.144.200.82]:42768 "EHLO
	neuralscape.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbYAKObF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 09:31:05 -0500
Received: from localhost.neuralscape.com ([127.0.0.1] helo=synapse.neuralscape.com)
	by neuralscape.com with esmtp (Exim 4.61)
	(envelope-from <shaeffer@synapse.neuralscape.com>)
	id 1JDKRk-0001KU-P4
	for linux-scsi@vger.kernel.org; Fri, 11 Jan 2008 06:01:20 -0800
Received: (from shaeffer@localhost)
	by synapse.neuralscape.com (8.13.6/8.13.6/Submit) id m0BE1KvN005113
	for linux-scsi@vger.kernel.org; Fri, 11 Jan 2008 06:01:20 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have this server with an LSI Logic SAS1064 RAID
enabled Ultra320 SCSI controller on the system board.
I am running a vanilla 2.6.23.12 kernel. Everything
runs well, except during the boot I see these logs
in dmesg and the syslogs.

mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000001h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000003h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000004h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000005h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000006h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000007h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000008h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=00000009h
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Ah
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Bh
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Ch
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Dh
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Eh
mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: type=08h, page=00h, action=01h, form=0000000Fh

I've traced through the mptbase.c code and can see these
invalid config pages are read from the controller during
initialization. This doesn't appear to cause any ill
effects, but I am wondering how to resolve this? Maybe
a MPT BIOS or MPT firmware upgrade will fix this?

Thanks,
Karen
-- 
 Karen Shaeffer
 Neuralscape, Palo Alto, Ca. 94306
 shaeffer@neuralscape.com  http://www.neuralscape.com
