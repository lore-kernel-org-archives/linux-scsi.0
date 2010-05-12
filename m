From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.13: Update lpfc to revision 8.3.13
Date: Wed, 12 May 2010 09:29:53 -0400
Message-ID: <1273671013.24670.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16313 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923Ab0ELNaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 09:30:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.13

The patches for 8.3.13 contain:
- FC Discovery Fixes and enhancements.
- Initialization code clean up and fixes.
- SCSI specific changes
- Misc fixes.
- BSG management fixes.
- Add TX Queue Support for SLI4 ELS commands.
- Update Driver Version to 8.3.13

The bugfixes were cut against scsi-misc-2.6.


-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




