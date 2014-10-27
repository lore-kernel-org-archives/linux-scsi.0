From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/2] TUR path is down after adapter gets reset in multipath configuration
Date: Mon, 27 Oct 2014 13:01:47 -0500
Message-ID: <20141027180147.030955587@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58152 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752104AbaJ0SHY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 14:07:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Based on Christoph's and Brian's patches, these patch fix the TUR path is down after adapter gets reset issue.


Thanks,
Wendy
-- 
