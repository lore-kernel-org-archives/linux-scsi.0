From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.18: Update lpfc to revision 8.3.18
Date: Fri, 22 Oct 2010 11:05:25 -0400
Message-ID: <1287759935.11844.17.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56052 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755236Ab0JVPGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:06:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.18

The patches for 8.3.18 contain:
- FC/FCoE Discovery fixes
- Add support of received ELS commands
- Add logic to detect last devloss timeout
- Adapter Shutdown and Unregistration cleanup
- Fix critical errors
- Add new WQE support
- Update lpfc driver version to 8.3.18

The bugfixes were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




