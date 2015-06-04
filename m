From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 0/10] qla2xxx: Fix various warnings reported by static
 source code analysis tools
Date: Thu, 4 Jun 2015 15:51:02 -0700
Message-ID: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bbn0100.outbound.protection.outlook.com ([157.56.111.100]:13344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbbFDWvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:51:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch series addresses several warnings reported by static source
code analysis tools for the qla2xxx driver (gcc (W=1), sparse (C=2) and
smatch (C=2 CHECK="smatch -p=kernel")). The patches in this series are:

0001-qla2xxx-Declare-local-functions-static.patch
0002-qla2xxx-Remove-set-but-not-used-variables.patch
0003-qla2xxx-Replace-two-macros-with-an-inline-function.patch
0004-qla2xxx-Remove-__constant_-prefix.patch
0005-qla2xxx-Specify-the-noderef-attribute-once.patch
0006-qla2xxx-Fix-sparse-annotations.patch
0007-qla2xxx-Remove-a-superfluous-test.patch
0008-qla2xxx-Remove-unreachable-code.patch
0009-qla2xxx-Comment-out-unreachable-code.patch
0010-qla2xxx-Fix-indentation.patch

The changes compared to v1 of this series are:
- Rebased this patch series onto kernel v4.1-rc6.
- Also removed variable 'd2' in patch 3.
- Also remove the recently introduced dead code in patch 10.
