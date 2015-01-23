From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/17] Clear up bidi command confusion
Date: Fri, 23 Jan 2015 13:05:30 +0100
Message-ID: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0097.outbound.protection.outlook.com ([157.56.110.97]:52256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750791AbbAWMFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:05:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

There is some confusion in the SCSI core and in SCSI LLDs around the
meaning of sc_data_direction and whether or not this member can have the
value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
series are:

0001-Clear-up-sc_data_direction-documentation.patch
0002-Clean-up-scsi_ioctl_reset.patch
0003-sg-Remove-an-unused-variable.patch
0004-dpt_i2o-Fix-bidi-command-test.patch
0005-aachba-Fix-bidi-command-test.patch
0006-eata-Remove-dead-code.patch
0007-sbp2-Fix-bidi-command-test.patch
0008-ibmvscsi-Fix-bidi-command-test.patch
0009-cciss-Remove-dead-code.patch
0010-hpsa-Remove-dead-code.patch
0011-3w-9xxx-Remove-dead-code.patch
0012-ncr53c8xx-Fix-bidi-command-support.patch
0013-qla1280-Fix-bidi-command-support.patch
0014-53c700-Remove-dead-code.patch
0015-mvumi-Remove-dead-code.patch
0016-sym_glue-Fix-bidi-command-test.patch
0017-IB-srp-Detect-bidi-commands-properly.patch
