From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 00/11] aacraid driver updates
Date: Thu, 26 Mar 2015 10:41:21 -0400
Message-ID: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50161 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbbCZOqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:46:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

This patch set includes some important bug fixes and new feature supports.

V2:
Separated unrelated patches from the VPD support one
Fixed indentation issues
Separated version increase and applied at the end

Mahesh Rajashekhara (11):
  aacraid: AIF support for SES device add/remove
  aacraid: IOCTL pass-through command fix
  aacraid: 4KB sector support
  aacraid: MSI-x support
  aacraid: vpd page code 0x83 support
  aacraid: 240 simple volume support
  aacraid: IOP RESET command handling changes
  aacraid: IOCTL fix
  aacraid: performance improvement changes
  aacraid: AIF raw device remove support
  aacraid: driver version change

 drivers/scsi/aacraid/aachba.c   |  410 +++++++++++++++++++++++++++++++------
 drivers/scsi/aacraid/aacraid.h  |  106 +++++++++-
 drivers/scsi/aacraid/commctrl.c |   10 +-
 drivers/scsi/aacraid/comminit.c |  106 +++++++++-
 drivers/scsi/aacraid/commsup.c  |   96 +++++++--
 drivers/scsi/aacraid/dpcsup.c   |   13 +-
 drivers/scsi/aacraid/linit.c    |   61 ++++--
 drivers/scsi/aacraid/rx.c       |   14 +-
 drivers/scsi/aacraid/src.c      |  438 +++++++++++++++++++++++++++++---------
 9 files changed, 1012 insertions(+), 242 deletions(-)

-- 
1.7.7.3

