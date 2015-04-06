From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [V2 PATCH 00/11] aacraid driver updates
Date: Mon, 6 Apr 2015 11:02:58 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F4DF79@BBYEXM01.pmc-sierra.internal>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55980 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbbDFLDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2015 07:03:03 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Achim Leubner <Achim.Leubner@pmcs.com>

Hi James,

Can you please let me know the status of this patch set.

This V2 patch set was reviewed by Hannes and Murthy.

Thanks,
Mahesh  

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Thursday, March 26, 2015 8:11 PM
To: hare@suse.de; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: Achim Leubner; Mahesh Rajashekhara
Subject: [V2 PATCH 00/11] aacraid driver updates

This patch set includes some important bug fixes and new feature supports.

V2:
Separated unrelated patches from the VPD support one Fixed indentation issues Separated version increase and applied at the end

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

