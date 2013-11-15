From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] fix WARN_ON in dual path device
Date: Fri, 15 Nov 2013 10:46:01 -0600
Message-ID: <20131115164601.223247118@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60028 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751067Ab3KOQ5v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Nov 2013 11:57:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

The patch fixes sysfs warnnings when remove module in daul controller
configuration.

Thanks,
Wendy
-- 
