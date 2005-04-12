From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: evaluation of scsi_cmnd->resid
Date: Tue, 12 Apr 2005 20:04:43 +0200
Message-ID: <20050412180443.GA7395@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:24512 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S262392AbVDLSDv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 14:03:51 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j3CI3nFa126612
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 18:03:49 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3CI3nxU223740
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 20:03:49 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j3CI3nMs019983
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 20:03:49 +0200
Received: from lion28.boeblingen.de.ibm.com (lion28.boeblingen.de.ibm.com [9.152.242.26])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j3CI3ntg019980
	for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 20:03:49 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

Am I right in the assumption that scsi_cmnd->resid is just of use for
requests initiated by sg?

How does the SCSI-stack handle normal (non-sg) requests for SCSI disks
for which a scsi_cmnd->resid is set?  AFAIK, resid is ignored by
sd. So, such requests are returned to the block layer although the
amount of data transferred is less the amount of data that should have
been transferred.  For FCP-drivers this means that some error situations
cannot be handled by just using scsi_cmnd->resid.

What am I missing here?


Regards,

Andreas
