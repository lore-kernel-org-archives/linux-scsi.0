From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] ipr: possible irq lock inversion dependency detected
Date: Fri, 24 May 2013 09:59:12 -0500
Message-ID: <20130524145912.801776828@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:43898 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755097Ab3EXPCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 11:02:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Hi All,

When enable lockdep, seeing "possible irq lock inversion dependency detected"
error. This patch fixed the issue.

Thanks,
Wendy
-- 
