From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/8] V2 Add support for new IBM SAS controllers
Date: Fri, 11 Jan 2013 17:43:46 -0600
Message-ID: <20130111234346.012076652@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:41488 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755681Ab3AKXrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2013 18:47:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

This is version 2 of ipr patches to support new IBM SAS controllers. 
In V2, we have fixed the following suggestions/warning/sparse errors:

1.Changed simple_strtoul() to kstrtoul() in ipr_restore_iopoll_weight routine.
2.Removed the __dev annotations.
3.Fixed unlock bugs which are caused by my previous patches(reported by sparse).
4.BUG_ON gcc 4.7 warning.
5.Fixed sparse error in original ipr driver.

Let me know if you have any questions.

Thanks for your help!
Wendy
-- 
