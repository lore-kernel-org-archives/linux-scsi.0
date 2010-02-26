From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.10: Update lpfc to revision 8.3.10
Date: Fri, 26 Feb 2010 14:12:10 -0500
Message-ID: <1267211550.3372.0.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4805 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965792Ab0BZTNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:13:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.10

The patches for 8.3.10 contain:
- Fix Initialization issues
- Fix user interface issues
- Update SLI interface areas
- Added management for LP21000 through BSG.
- Fix Discovery issues
- Added round robin FCF failover
- Update Driver version to 8.3.10

The bugfixes were cut against scsi-misc-2.6


-- james s


  Signed-off-by: James Smart <james.smart@emulex.com>




