From: Marc Bowes <marcbowes@gmail.com>
Subject: SATA: link online but device misclassified
Date: Wed, 10 Jun 2009 22:31:32 +0200
Message-ID: <cfa4e840906101331q71532d72v5361a72e9b77ce63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:33554 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZFJUbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 16:31:31 -0400
Received: by ewy6 with SMTP id 6so1349386ewy.37
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 13:31:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

Firstly, I hope that the SCSI list is the correct place to ask about SATA.

I just got a new chipset (Gigabyte EP45-DQ6) courtesy of a
competition. This coincided with the death of a hard drive. I had to
reinstall my Gentoo system on the new hard drive, and hit this issue
when booting the newly configured Kernel (2.6.29-gentoo-r5):

ata1: link is slow to respond, please be patient (ready=0)
ata1: softreset failed (device not ready)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: link online but device misclassified, retrying
ata1: link is slow to respond, please be patient (ready=0)
ata1: softreset failed (device not ready)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: link online but device misclassified, retrying
ata1: link is slow to respond, please be patient (ready=0)
ata1: softreset failed (device not ready)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: link online but device misclassified, retrying
ata1: limiting SATA link speed to 1.5 Gbps
ata1: softreset failed (device not ready)
ata1: SATA link up to 1.5 Gbps (SStatus 113 SControl 310)
ata1: link online but device misclassified, device detection might fail
ata2: link is slow to respond, please be patient (ready=0)
ata2: softreset failed (device not ready)
... (as with ata1)

This whole process takes a very long time (minutes) to finish. It
seems to be down-grading two of the four SATA-2 drives to SATA-1
speeds. The drives are actually SATA-2 drives, and appear to work (at
full speed) on my Windows 7 install.

Please advise.

Best,
Marc
