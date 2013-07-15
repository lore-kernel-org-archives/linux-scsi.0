From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/13] lpfc 8.3.41: Update lpfc to revision 8.3.41
Date: Mon, 15 Jul 2013 18:31:25 -0400
Message-ID: <1373927485.15647.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19197 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab3GOWb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:31:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.41

The patches for 8.3.41 contain:

- Fixed freeing of iocb when internal loopback times out
- Fix mailbox byteswap issue on PPC
- Fixed Receive Queue varied frame size handling 
- Fixed max value of lpfc_lun_queue_depth
- Ensure driver properly zeros unused fields in SLI4 mailbox commands
- Fixed support for 128 byte WQEs 
- Fixed SLI3 failing FCP write on check-condition no-sense with residual zero
- Fixed failure in setting SLI3 board mod
- Fixed not able to perform PCI function reset when board was not in online mode
- Add first burst support to driver
- Fixed the format of some log message fields
- Update copyrights for 8.3.41 modifications
- Update lpfc version to driver version 8.3.41 


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>







