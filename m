From: rohan a <info1686@gmail.com>
Subject: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Wed, 15 Jul 2009 10:07:10 +0530
Message-ID: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:46860 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZGOEnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 00:43:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hello,
        The SCSI command for LTO-4 drive based encryption (SPOUT
opcode = 0xB5) is failing on SLES 9 32-bit only and not on SLES 9 (64-
bit), SLES 10,11 or RHEL 4/5

Any idea why this is happening?

Error returned is : Invalid field in CDB

I am using ioctl() with the deprecated request SCSI_IOCTL_SEND_COMMAND
and not the SG3 driver.
However, only the SPOUT command is failing and none of the other SCSI
commands.
For ex: even the SPIN command (to obtain encryption status and
capabilities) works.

I even updated to SP4.

Any suggestions here?

Thanks
