From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/7] RESEND Add support for new IBM SAS controllers
Date: Mon, 03 Dec 2012 12:31:12 -0600
Message-ID: <20121203183112.822371464@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:12392 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751418Ab2LCSe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 13:34:27 -0500
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
