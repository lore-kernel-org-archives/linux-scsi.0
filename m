From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/6][REPOST] lpfc 8.3.13: Update lpfc to revision 8.3.13
Date: Mon, 7 Jun 2010 15:23:08 -0400
Message-ID: <1275938608.9049.11.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38381 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745Ab0FGTYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 15:24:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.13

This is a reposting of the original patch set, minus the
patch for BSG-related changes. We will work the BSG issue
independently.

The patches for 8.3.13 contain:
- FC Discovery Fixes and enhancements.
- Initialization code clean up and fixes.
- SCSI pecific changes
- Misc fixes.
- Add TX Queue Support for SLI4 ELS commands.
- Updave Driver Version to 8.3.13

The bugfixes were cut against scsi-misc-2.6.


-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




