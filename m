From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/5] lpfc 8.3.20: Update lpfc to revision 8.3.20
Date: Wed, 15 Dec 2010 17:56:49 -0500
Message-ID: <1292453823.32478.23.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15414 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192Ab0LOW50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 17:57:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.20

The patches for 8.3.20 contain:
- Critical fixes.
- Implement the FC and SLI async event handlers.
- Implement new SLI4 init procedures based on if_type
- Updates to FC discovery commands
- Update lpfc driver version to 8.3.20

The bugfixes were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




