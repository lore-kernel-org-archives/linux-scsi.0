From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] ipr_test_msi() failed when running msi-x enabled adapter
Date: Wed, 27 Feb 2013 12:37:44 -0600
Message-ID: <20130227183744.430469620@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:6629 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1758245Ab3B0SqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2013 13:46:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

Loading ipr module failed(-22)with msi-x enabled adapter. This patch
fixes the issue.

Thanks for your help!
Wendy
-- 
