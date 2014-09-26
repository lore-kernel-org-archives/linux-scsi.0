From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 0/2] be2iscsi : Update to 10.4.114.0
Date: Fri, 26 Sep 2014 15:13:31 -0400
Message-ID: <ac10c6c1-57b3-4d39-b5be-7af9fb343e95@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:14186 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaIZJqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 05:46:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>

 This patchset updates be2iscsi driver to 10.4.114.0
 These patches are based on for-next branch of scsi.git.

John Soni Jose (2):
  be2iscsi : Fix kernel panic during reboot/shutdown
  be2iscsi : Bump the driver version

 drivers/scsi/be2iscsi/be_main.c |    2 +-
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

