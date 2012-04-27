From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: pull request: linux-firmware: Update qla2xxx firmware files.
Date: Fri, 27 Apr 2012 15:41:21 -0400
Message-ID: <alpine.WNT.2.00.1204271521300.1704@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:25616
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760737Ab2D0Tlb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 15:41:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ben@decadent.org.uk, dwmw2@infradead.org
Cc: andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Hi Ben, David,

Can you please pull the following patches from the "for_upstream" branch
of the repo below to update the ql2300_fw.bin, ql2322_fw.bin,
ql2400_fw.bin and ql2500_fw.bin files?

git://avgit01.qlogic.org/linux-firmware for_upstream

Chad Dupuis (4):
   qla2xxx: Update ql2300_fw.bin to version 3.03.28.
   qla2xxx: Update ql2322_fw.bin to version 3.03.28.
   qla2xxx: Update ql2400_fw.bin to version 5.06.05.
   qla2xxx: Update ql2500_fw.bin to version 5.06.05.

  WHENCE        |    8 ++++----
  ql2300_fw.bin |  Bin 123170 -> 125252 bytes
  ql2322_fw.bin |  Bin 132978 -> 136038 bytes
  ql2400_fw.bin |  Bin 228056 -> 255320 bytes
  ql2500_fw.bin |  Bin 199776 -> 252636 bytes
  5 files changed, 4 insertions(+), 4 deletions(-)

Thanks,
Chad

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

