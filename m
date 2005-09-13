From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 0/6] zfcp: update to driver version 4.5.0
Date: Tue, 13 Sep 2005 21:46:29 +0200
Message-ID: <20050913194629.GA7654@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:53669 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S932422AbVIMTtH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:49:07 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8DJn6TZ168858
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 19:49:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8DJn57u084576
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:49:05 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8DJn50E023685
	for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:49:05 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

New attempt - this time with a series of 6 patches (based on
2.6.14-rc1) - to update the zfcp device driver. Patches contain
bugfixes, some cleanups and new features. Overall diffstat of all
patches is:

 Makefile             |    2 
 zfcp_aux.c           |  188 ---------
 zfcp_dbf.c           |  999 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 zfcp_def.h           |  295 +++++++++------
 zfcp_erp.c           |  119 +++++-
 zfcp_ext.h           |   30 +
 zfcp_fsf.c           |  718 ++++++++++++++++--------------------
 zfcp_fsf.h           |   54 ++
 zfcp_qdio.c          |   30 -
 zfcp_scsi.c          |  288 ++++----------
 zfcp_sysfs_adapter.c |    4 
 11 files changed, 1785 insertions(+), 942 deletions(-)


Regards,

Andreas
