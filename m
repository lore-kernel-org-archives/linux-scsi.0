From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] kexec: Export kexec_in_progress
Date: Tue, 20 May 2014 10:35:38 -0500
Message-ID: <537B764A.7040801@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55428 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbaETPgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 11:36:45 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 20 May 2014 11:36:44 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 55B966E804D
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2014 11:36:30 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4KFaU3j63570118
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2014 15:36:38 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4KFa4h5030197
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2014 11:36:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Wen Xiong <wenxiong@us.ibm.com>, kexec@lists.infradead.org, ebiederm@xmission.com


Export kexec_in_progress for use by device drivers and other modules
to optimize kexec boot.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
--- linux/kernel/kexec.c~kexec_export_in_prog	2014-05-13 16:59:19.000000000 -0500
+++ linux-bjking1/kernel/kexec.c	2014-05-13 16:59:19.000000000 -0500
@@ -1712,3 +1712,5 @@ int kernel_kexec(void)
 	mutex_unlock(&kexec_mutex);
 	return error;
 }
+
+EXPORT_SYMBOL_GPL(kexec_in_progress);
_

