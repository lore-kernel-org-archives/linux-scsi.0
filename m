From: Helge Hafting <helge.hafting@broadpark.no>
Subject: Is there hope for this drive?
Date: Tue, 03 Aug 2004 07:21:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410F20F6.40802@broadpark.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.broadpark.no ([217.13.4.2]:26007 "EHLO mail.broadpark.no")
	by vger.kernel.org with ESMTP id S264915AbUHCFZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 01:25:51 -0400
Received: from broadpark.no (220.80-202-18.nextgentel.com [80.202.18.220])
	by mail.broadpark.no (Postfix) with ESMTP id 4B80A6C98
	for <linux-scsi@vger.kernel.org>; Tue,  3 Aug 2004 07:26:24 +0200 (MEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recently got a couple of used IBM Ultrastar drives.
They worked at first, but one of them suddenly stopped responding to
read/write requests.

"scsiinfo -i /dev/sdc" still provides info about it, but
"scsiinfo -a /dev/sdc" provides no more information because every operation
except the basic inquiry fails:
"Unable to read Rigid Disk Geometry Page 04h" and so on.

Partitioning and low-level formatting with scsiformat is impossible.

I wonder if there is anything more I could try before throwing away the drive.
It is strange to be able to "contact" the drive but not use it.  It spins up
at boot as it should.  Any ideas?

Helge Hafting
