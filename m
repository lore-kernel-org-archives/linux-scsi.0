From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 0/1] Error are logged when application issues illegal request
Date: Wed, 24 Sep 2014 16:25:46 -0500
Message-ID: <20140924212546.034058593@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58077 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752389AbaIXVje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 17:39:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Hi all,

Failing Device information are logged when IOA firmware detected these
illegal request such as IOA firmware doesn't support inquiry with page
code 2. The patch fixes the issue.

Thanks for your help!
Wendy

-- 
