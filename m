From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/18] lpfc 8.3.42: Update lpfc to revision 8.3.42
Date: Fri, 6 Sep 2013 12:17:44 -0400
Message-ID: <1378484264.14051.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:51723 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3IFQSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:18:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.42

The patches for 8.3.42 contain:

- Fixed using unsafe linked list macro for walking and deleting linked list
- Fixed not able to log informational messages at early stage of driver init time
- Fix ramdom errors using first burst
- Fixed mailbox memory leak.
- Back out data count,(residual fcfi_parm) fix for bad target.
- Fixed function mode field defined too small for not recognizing dual-chute mode
- Fixed race condition between BSG I/O dispatch and timeout handling
- Fixed back to back RSCNs discovery failure.
- Fixed logging format of setting driver sysfs attributes hard to interpret
- Fix crash on driver load due to cpu affinity logic
- Fixed driver iocbq structure's iocb_flag field running out of space
- Avoided making pci bar ioremap call during dual-chute WQ/RQ pci bar selection
- Fix WARN_ON when driver unloads
- Fixed failure to allocate SCSI buffer on PPC64 platform for SLI4 devices
- Fix driver's abort loop functionality to skip IOs already getting aborted
- Fixed inconsistent spin lock usage. 
- Fixed issue of task management commands having a fixed timeout
- Update lpfc version to driver version 8.3.42


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





