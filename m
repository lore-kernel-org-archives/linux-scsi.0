From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 13:39:49 -0500
Message-ID: <20130415183949.678757952@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:5105 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S933353Ab3DOSoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 14:44:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

In scsi_send_eh_cmnd(), this fix will check the return code of queuecomamnd
when sending commands and retry for a bit if the driver returns a
busy response.

Thanks,
Wendy

-- 
