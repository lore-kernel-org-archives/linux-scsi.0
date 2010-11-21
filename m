From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/6] lpfc 8.3.19: Update lpfc to revision 8.3.19
Date: Sat, 20 Nov 2010 23:13:57 -0500
Message-ID: <1290312852.32645.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23309 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752911Ab0KUEOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.19

The patches for 8.3.19 contain:
- Fix critical errors and crashes
- Add latest SLI4 Hardware initialization support
- Add SLI4 FC Discovery support
- Added support for ELS RRQ command
- Change heartbeat to default to disabled
- Update lpfc driver version to 8.3.19

The bugfixes were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




