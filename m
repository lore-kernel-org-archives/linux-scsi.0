From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Bug about mke2fs hang on AIC79 device
Date: Thu, 27 Nov 2008 10:18:38 +0800
Message-ID: <1227752318.2866.163.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYK0CTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 21:19:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: rjw@sisk.pl, michaelc@cs.wisc.edu, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

2.6.28-rc1 introduced a bug about scsi lib. We reported it at
http://bugzilla.kernel.org/show_bug.cgi?id=11898.

Patch at http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36 already fixes
the bug. But 2.6.28-rc6 has no the patch. Although there is a performance issue,
could you push the patch to upstream firstly? It seems the performance issue
isn't related to the patch.

Thanks,
Yanmin


