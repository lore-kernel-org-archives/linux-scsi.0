From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] ibmvscsis driver rewrite
Date: Thu, 10 Feb 2011 21:21:32 +0900
Message-ID: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49647 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab1BJM1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 07:27:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, fujita.tomonori@lab.ntt.co.jp

Finally, I have the working driver. We are ready to remove the old
ibmvstgt driver.

This is for scsi-misc tree.

=
 drivers/scsi/ibmvscsi/Makefile    |    4 +-
 drivers/scsi/ibmvscsi/ibmvscsis.c | 1759 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/libsrp.c             |   18 +-
 include/scsi/libsrp.h             |   10 +-
 4 files changed, 1778 insertions(+), 13 deletions(-)




