From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/8] lpfc 8.3.43: Update lpfc to revision 8.3.43
Date: Thu, 10 Oct 2013 12:19:15 -0400
Message-ID: <1381421955.20248.10.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49032 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3JJQTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:19:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.43

The patches for 8.3.43 contain:

- Fix crash after xri limit is reached.
- Fixed spinlock inversion problem.
- Fixed invalid mailbox timeouts
- Fixed invalid fcp_rsp length fir FCP_ICMND
- Fixed invalid Total_Data_Placed value received for els and ct command
  responses
- Fixed spinlock hang.
- Fixed not processing task management IOCB response status
- Update lpfc version to driver version 8.3.43


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





