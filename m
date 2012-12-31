From: CrashPlan Pro <linux-scsi@crashplan.pro>
Subject: What does scsi IO state flag 0x0C (= 0x08 && 0x04 == terminated &&
 no scsi status) mean?
Date: Mon, 31 Dec 2012 13:11:28 +0100
Message-ID: <50E180F0.3000300@crashplan.pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36403 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2LaMLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Dec 2012 07:11:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-scsi@crashplan.pro

mpi2_init.h contains:
#define MPI2_SCSI_STATE_TERMINATED              (0x08)
#define MPI2_SCSI_STATE_NO_SCSI_STATUS          (0x04)

What does it mean when for each SCSI IO (REPORT_LUNS, TEST_UNIT_READY) 
the state flag 0x0C (= 0x08 && 0x04) is returned?
