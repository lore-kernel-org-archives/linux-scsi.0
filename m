From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 0/10] qla2xxx: Fix various warnings reported by static
 source code analysis tools
Date: Thu, 9 Jul 2015 07:21:54 -0700
Message-ID: <559E8382.6030803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0069.outbound.protection.outlook.com ([157.56.111.69]:15904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751154AbbGIOWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 10:22:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch series addresses several warnings reported by static source
code analysis tools for the qla2xxx driver (gcc (W=1), sparse (C=2) and
smatch (C=2 CHECK="smatch -p=kernel")). The patches in this series are:

0001-qla2xxx-Report-both-rsp_info-and-rsp_info_len.patch
0002-qla2xxx-Declare-local-functions-static.patch
0003-qla2xxx-Remove-set-but-not-used-variables.patch
0004-qla2xxx-Replace-two-macros-with-an-inline-function.patch
0005-qla2xxx-Remove-__constant_-prefix.patch
0006-qla2xxx-Avoid-that-sparse-complains-about-duplicate-.patch
0007-qla2xxx-Fix-sparse-annotations.patch
0008-qla2xxx-Remove-a-superfluous-test.patch
0009-qla2xxx-Remove-dead-code.patch
0010-qla2xxx-Avoid-that-sparse-complains-about-context-im.patch

Version 3 is a resend of the patches from v2 that are not yet upstream.

The changes compared to v1 of this series are:
- Rebased this patch series onto kernel v4.1-rc6.
- Also removed variable 'd2' in patch 3.
- Also remove the recently introduced dead code in patch 10.
