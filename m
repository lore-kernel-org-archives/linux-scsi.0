From: Ketan Mukadam <ketan.mukadam@avagotech.com>
Subject: [PATCH 0/1] be2iscsi : Add warning message for unsupported devices
Date: Sat,  1 Aug 2015 03:49:49 +0530
Message-ID: <1438381189-6568-1-git-send-email-ketan.mukadam@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:51796 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbbGaFy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 01:54:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Ketan Mukadam <ketan.mukadam@avagotech.com>

Add a warning message to indicate obsolete/unsupported
BE2 Adapter Family devices

Ketan Mukadam (1):
  be2iscsi : Add warning message for unsupported adapter

 drivers/scsi/be2iscsi/be_main.c | 2 ++
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.3.1

