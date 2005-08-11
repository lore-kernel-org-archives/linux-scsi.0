From: Harald Seipp <SEIPP@de.ibm.com>
Subject: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 12:09:25 +0200
Message-ID: <OFBC81092C.89B6F4D5-ONC125705A.00365E9F-C125705A.0037CB40@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33482 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S964877AbVHKKMv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 06:12:51 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7BACoxt145302
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 10:12:50 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BACoo2181720
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 12:12:50 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7BACo0T029629
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 12:12:50 +0200
Received: from d12ml068.megacenter.de.ibm.com (d12ml068.megacenter.de.ibm.com [9.149.164.163])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j7BACoLQ029624
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 12:12:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[ Please CC any replies; I am not on this list]

I have two systems, each with at least two SCSI HDDs attached&mounted:
SLES 9 (2.6.5-7.151-smp)
Knoppix 3.9 (2.6.11.10)
If I execute echo "scsi remove-single-device h b t l" > /proc/scsi/scsi on
a mounted HDD target, the device will be _removed_. A subsequent echo "scsi
add-single-device h b t l" > /proc/scsi/scsi on the same target will cause
the device to be re-added, but it will appear at a different (next free)
device file (e.g. /dev/sda will become /dev/sdc when two HDDs are
attached).
This behavior does not appear when running kernel 2.4-based systems on the
same machines, the mounted HDDs will not be touched.

I assume this is a bug? How can I prevent that behavior? Can I easily query
if a device on "h b t l" is mounted to work-around?

Regards,
Harald Seipp,
IBM Systems and Technology Group

