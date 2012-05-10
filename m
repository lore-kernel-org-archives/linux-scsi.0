From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/20] lpfc 8.3.31: Update lpfc to revision 8.3.31
Date: Wed, 9 May 2012 21:15:50 -0400
Message-ID: <1336612560.1996.29.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27863 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751347Ab2EJBQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:16:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.31

The patches for 8.3.31 contain:

- Fix bug with driver unload leaving a scsi host for a vport around.
- Correct handling of SLI4-port XRI resource-provisioning profile change
- Fix bug with driver not supporting the get controller attributes command.
- Fix initiator sending flogi after acking flogi from target.
- Fix unable to create vports on FCoE SLI4 adapter
- Fixed system panic due to midlayer abort and driver complete race on SCSI cmd
- Fix Read Link status data.
- Fix error message displayed even when not an error.
- Fix kernel panic when going into to sleep state
- Fix build warnings when debugfs is not defined
- Revise FCP LOG for easier Finisar trace correlation
- Fix log message for Mailbox command when no error is detected.
- Fix driver crash during back-to-back ramp events.
- Reregister VPI for SLI3 after cable moved to new Saturn port
- Correct point-to-point mode discovery errors on LPe16xxx (CR: 130446)
- Fix unsol abts xri lookup.
- Debug helper utility routines for dumping various SLI4 queues
- Fix bug with driver using the wrong xritag when sending an els echo.
- Fixed system crash due to not providing SCSI error-handling host reset handler
- Update lpfc to version 8.3.31

The patches were cut against scsi.git

-- james s


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>





