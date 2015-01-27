From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/10] qla2xxx: Fix various warnings reported by static source
 code analysis tools
Date: Tue, 27 Jan 2015 10:31:36 +0100
Message-ID: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:9883
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753836AbbA0Jbp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:31:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

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
0010-qla2xxx-Comment-out-dead-code.patch
