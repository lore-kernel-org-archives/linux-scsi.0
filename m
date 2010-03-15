From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/6] lpfc 8.3.11: Update lpfc to revision 8.3.11
Date: Mon, 15 Mar 2010 11:24:44 -0400
Message-ID: <1268666684.31367.12.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57384 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965164Ab0COPZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.11

The patches for 8.3.11 contain:
- FCF failover improvements.
- SLI4 Improvements.
- Driver management improvements via BSG.
- Fix AER uncorrectable non-fatal error handling
- NPIV changes
- Update Driver version to 8.3.11

The bugfixes were cut against scsi-misc-2.6


-- james s


  Signed-off-by: James Smart <james.smart@emulex.com>




