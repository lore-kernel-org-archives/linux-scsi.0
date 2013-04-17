From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] ipr: Need to reset adapter after the 6th EEH error
Date: Wed, 17 Apr 2013 09:34:05 -0500
Message-ID: <20130417143405.849599713@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:8158 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S966493Ab3DQOjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 10:39:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

After errinjct the 6th EEH error on adapter, disk configuration 
not restore. This patch fixes ths issue.

Thanks,
Wendy
-- 
