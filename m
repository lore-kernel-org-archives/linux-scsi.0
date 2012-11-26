From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/7] Add support for new IBM SAS controllers
Date: Mon, 26 Nov 2012 09:55:34 -0600
Message-ID: <20121126155534.352187900@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:8143 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754405Ab2KZQGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

The new generation IBM SAS controllers will support MSI-X interrupt and
Distributed Completion Processing features. The patches in this series
add the code to support these new hardware features and also add some
patches for performance improvement such as block iopoll and reducing
lock contention in ipr driver.

Thanks for your help!
Wendy

-- 
