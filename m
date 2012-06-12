From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/10] lpfc 8.3.32: Update lpfc to revision 8.3.32
Date: Tue, 12 Jun 2012 13:53:54 -0400
Message-ID: <1339523635.2162.0.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17641 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab2FLRyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.32

The patches for 8.3.32 contain:

- drivers/scsi/lpfc/lpfc_sli.c: add missing jumps to mempool_free
- Correct Smatch Error in lpfc_sli.c
- Fix CQ and EQ dump failure for debugfs
- Correct host DIF configuration that hung system 
- Correct provisioning change failure on local function
- Correct successful aborts returning error status
- Fix ability to change FCP EQ delay multiplier
- Fix system panic due to node state change
- Fix error reporting of misconfigured ports
- Update lpfc to version 8.3.32

The patches were cut against scsi.git

-- james s


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>





