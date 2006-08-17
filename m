From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/3] lpfc 8.1.9 : lpfc 8.1.9 patches
Date: Thu, 17 Aug 2006 11:57:49 -0400
Message-ID: <1155830269.24351.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60589 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932548AbWHQP5k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 11:57:40 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7HFvd0p014542
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 08:57:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.1.9. These patches
are intended for scsi-rc-fixes-2.6 and should get pulled into 2.6.18.

Changes include:
- Misc Bug Fixes:
  - Cap MBX_DOWN_LINK command timeout to 60 seconds
  - Fix double free of ndlp object
  - Don't free mbox structures on error. The completion handlers expect to
    do so.
  - Clear host attention work items when going offline
  - Fixed discovery issues in multi-initiator environments.
- Stall error handler if attempting resets/aborts while an rport is blocked.
    This avoids device offline scenarios due to errors in the error handler.
- Change version number to 8.1.9

-- james s



