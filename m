From: Liran Schour <LIRANS@il.ibm.com>
Subject: Minimize number of probed LUNs
Date: Tue, 2 May 2006 11:46:36 +0300
Message-ID: <OFAD5F457C.BC8CA508-ONC2257162.002F7FA0-C2257162.00303650@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40293 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S932513AbWEBItn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 May 2006 04:49:43 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.6/8.13.6) with ESMTP id k428ngis143592
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 08:49:42 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k428orMP107756
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 10:50:53 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k428nfUt004413
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 10:49:41 +0200
Received: from d12mc102.megacenter.de.ibm.com (d12mc102.megacenter.de.ibm.com [9.149.167.114])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id k428nfLw004410
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 10:49:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sivan Tal <SIVANT@il.ibm.com>


Hi,
I am looking for a mechanisms to control the number of probed LUNs in a SAN
environment.
I have too many disks over the net I don't want a specific machine to "see"
all LUNs.
I am looking for a solution that is above the SCSI transport layer (no LUN
masking or zoning).
Does anybody know about solutions for this?

- Liran

