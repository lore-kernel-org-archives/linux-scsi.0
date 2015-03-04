From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 0/7] aacraid driver updates
Date: Wed, 4 Mar 2015 03:38:26 -0500
Message-ID: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60583 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757302AbbCDJAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 04:00:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rajinikanth.Pandurangan@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

This patch set includes some important bug fixes and new feature supports.

Mahesh Rajashekhara (7):
  aacraid: AIF support for SES device add/remove
  aacraid: IOCTL pass-through command fix
  aacraid: 4KB sector support
  aacraid: MSI-x support
  aacraid: vpd page code 0x83 support
  aacraid: performance improvement changes
  aacraid: AIF raw device remove support

 drivers/scsi/aacraid/aachba.c   |  355 +++++++++++++++++++++++++++++------
 drivers/scsi/aacraid/aacraid.h  |  102 +++++++++-
 drivers/scsi/aacraid/commctrl.c |   10 +-
 drivers/scsi/aacraid/comminit.c |  106 ++++++++++-
 drivers/scsi/aacraid/commsup.c  |   78 ++++++--
 drivers/scsi/aacraid/dpcsup.c   |   13 +-
 drivers/scsi/aacraid/linit.c    |   48 +++--
 drivers/scsi/aacraid/rx.c       |   14 +-
 drivers/scsi/aacraid/src.c      |  404 +++++++++++++++++++++++++++++----------
 9 files changed, 894 insertions(+), 236 deletions(-)

-- 
1.7.7.3

