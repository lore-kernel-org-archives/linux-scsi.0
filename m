From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 00/11] hpsa updates
Date: Sat, 18 Jul 2015 11:12:17 -0500
Message-ID: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:34171 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbGRQOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:14:36 -0400
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 53B665608
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jul 2015 16:14:36 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - Static checker issues reported by Dan Carpenter
   - double unlock of a mutex
   - correct decode sense data decision
   - warnings on hpsa_init_one cleanup
 - Update PMC copyright
 - Cleanup update scsi devices
 - New controller ids.
 - Correct rmmod issue
 - Add in new path_info to show box and bay info
 - Driver supports mixed mode, RAID and HBA
 - New offline mode
 - Bug fix for multi lun devices from Shane Seymour

---

Don Brace (7):
      hpsa: Correct double unlock of mutex
      hpsa: correct decode sense data
      hpsa: correct static checker warnings on driver init cleanup
      hpsa: add PMC to copyright
      hpsa: cleanup update scsi devices
      hpsa: add in new controllers
      hpsa: fix rmmod issues

Joe Handzik (1):
      hpsa: add sysfs entry path_info to show box and bay information

Kevin Barnett (1):
      Change how controllers in mixed mode are handled.

Scott Benesh (1):
      hpsa: add in new offline mode

shane.seymour (1):
      hpsa: fix issues with multilun devices


 drivers/scsi/hpsa.c     |  286 +++++++++++++++++++++++++++++------------------
 drivers/scsi/hpsa.h     |   16 +--
 drivers/scsi/hpsa_cmd.h |   10 +-
 3 files changed, 188 insertions(+), 124 deletions(-)

--
Signature
