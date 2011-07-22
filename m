From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/8] lpfc 8.3.25: Update lpfc to revision 8.3.25
Date: Fri, 22 Jul 2011 18:36:10 -0400
Message-ID: <1311374175.10545.27.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:5985 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999Ab1GVWgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 18:36:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.25 for the
linux 3.1 merge window

The patches for 8.3.25. contain:

- T10 DIF Fixes
- Miscellaneous Bug fixes and code cleanup
- Adapter Interface fixes and changes
- Fabric and Target Discovery Fixes
- PCI and SR-IOV Fixes
- Enhancements to Debug infrastructure
    Note: This patch Subsumes the updated debugfs patch that was in 8.3.24
      that James Bottomley has yet to apply.
      http://marc.info/?l=linux-scsi&m=130655514918715&w=2
- Add FCF priority failover functionality
- Change driver version to 8.3.25
     Note: This patch Subsumes the version patch that was in 8.3.24
      that James Bottomley has yet to apply.
      http://marc.info/?l=linux-scsi&m=130625191125321&w=2


The patches were cut against scsi-misc-2.6

-- james s


  Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
  Signed-off-by: James Smart <james.smart@emulex.com>




