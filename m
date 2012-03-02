From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/21] lpfc 8.3.30: Update lpfc to revision 8.3.30
Date: Thu, 1 Mar 2012 22:33:07 -0500
Message-ID: <1330659190.18500.27.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38839 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752690Ab2CBDdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:33:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.30

The patches for 8.3.30 contain:

- Make BA_ACC work on a fully qualified exchange (CR: 126289)
- Fix bug with driver not sending a LOGO with vport delete.
- Fixed port and system failure in handling SLI4 FC port function reset
- Fix driver handling of XRI Aborted CQE response
- Fix same RPI registered multiple times after HBA reset
- Fix deadlock during adapter offline request.
- Fixed missing CVL event causing round-robin FCF failover process
  to stop (CR: 123367)
- Fixed SLI4 driver module load and unload test in a loop
  crashes the system (CR: 126397)
- Fix resource leak when acc fails for received plogi.
- Fixed the system panic during EEH recovery
- Add additional compilation flag
- Fixed system panic when extents enabled with large number of small blocks
- Update copyright date for files modified in 2012.
- Used PCI configure space read to flush PCI funciton reset register write
- Change default DA_ID support from disabled to enabled
- Enhancements for T10 DIF debugfs error injection for DVT usage (CR: 123966)
- Fix bug with mailbox handling of REG_VFI and cable pull.
- Update copyright date for files modified in 2012.
- Added some more features for T10 DIF debugfs error injection (CR: 123966)
- Revert fix for Link Pull Causes I/O Failures
- Update lpfc to version 8.3.30


The patches were cut against scsi-misc-2.6

-- james s


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>





