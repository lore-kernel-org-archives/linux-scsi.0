From: support <support@degrp.de>
Subject: system hangs while loading megaraid driver with kernel 2.6.0
Date: Mon, 5 Jan 2004 10:46:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1596424364.20040105104623@degrp.de>
Reply-To: support <support@degrp.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.degrp.de ([62.225.179.11]:46094 "EHLO mail.degrp.de")
	by vger.kernel.org with ESMTP id S263173AbUAEJqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 04:46:32 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We updated our HP Netserver LH4r with HP Netraid 3Si (RAID Controller)
(BIOS B.02.04 Nov.11.2002) from Kenrel 2.4.23 to 2.6.0. The Systems
hangs while booting with the following message.

megaraid: v2.00.3
megaraid: found 0x8086:0x1960:Bus 0:slot2:func 1
SCSI0: Found Megaraid Controller at 0xe082F000, IRQ:26

The old megaraid driver in kernel 2.4.23 worked fine. The megaraid2
driver had the same problem.

-- 
Best regards,
 Thomas Schend                          mailto:support@degrp.de

