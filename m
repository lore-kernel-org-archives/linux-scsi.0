From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 15:14:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF674A6508.2E30D394-ONC1256EA0.003A71C5-C1256EA0.00493D5D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:35576 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S265688AbUEZNOd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 09:14:33 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id i4QDEWGP113772
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 13:14:32 GMT
Received: from d12ml067.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i4QDEVnU154410
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 15:14:32 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





Is there a SCSI mid layer interface that allows an lldd to get a
SCSI devices back online?

The SCSI mid layer sets devices offline if it fails to recover them.
Nevertheless, an lldd might see some event that indicates
that a device has become accessible again. Why not give the mid
layer a hint in order to have it re-enable the device?
One aspect that could make this harder is that the mid layer
may wish to test the device instead of buying the lldd's indication
unseen. The alternative would be to try to use the device and to
offline it again if needed.

I have seen a system that loses paths (EVMS) to SCSI
devices that were set offline. Getting these paths operational
again seems to be required for a reliable failback.

Is scsi_device_resume() a good starting point?
Any thoughts?

Cheers,
Martin

