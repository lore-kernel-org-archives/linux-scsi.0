From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 0/7] aacraid driver updates
Date: Mon, 16 Mar 2015 11:24:17 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F40789@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54192 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbbCPLYc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Mar 2015 07:24:32 -0400
In-Reply-To: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Hi James,

Can you please let me know the status of this patch set which I submitted sometime back.

Thanks,
Mahesh

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, March 04, 2015 2:08 PM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pandurangan; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 0/7] aacraid driver updates

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

