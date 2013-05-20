From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/0] ipr: possible irq lock inversion dependency detected
Date: Mon, 20 May 2013 13:09:40 -0500
Message-ID: <20130520180940.750643868@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:44877 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757697Ab3ETSPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 May 2013 14:15:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

When enable lockdep, seeing "possible irq lock inversion dependency detected"
error. This patch fixes the issue.


Thanks for your help!
Wendy
