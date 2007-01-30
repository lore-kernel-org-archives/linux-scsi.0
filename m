From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 00/12] Roll-up of sas_ata patches
Date: Tue, 30 Jan 2007 04:15:56 -0500
Message-ID: <200701300915.l0U9FuPu010198@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37752 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965416AbXA3JP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:15:58 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9Fvl5017048
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:57 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9FuJf267250
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:56 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9FuAp010205
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:15:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Hi all,

This is a roll-up of all of my ATA related uncommitted patches against
libsas and aic94xx to date.  Per James Bottomley's request, I'm pushing
these patches out for further review in aic94xx-sas.  The big changes in
this patch set are a lot of bug and locking fixes, the conversion of the
EH routines to interact with the SAS EH strategy routines, and of course
the separation of the SATL code into a separate module.

These patches should apply in number order cleanly against 2.6.20-rc6 +
scsi_misc + scsi-rc-fixes + aic94xx-sas.  They've been fairly well tested
on a bunch of SATA disks in a x206m, though the ATAPI support is not so
well tested.  However, I have run these patches in other loads for a while.
Hopefully these patches are ready for more widespread testing in
scsi-misc, and thank you for any comments or feedback that you provide.

(Apologies for any stgit mail misconfiguration on my part.)

--D
