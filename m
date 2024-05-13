Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC614D2B2;
	Mon, 13 May 2024 12:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715601674; cv=none; b=RmZmOmtqG8SIwRomyCbuUV68buVw4S27vJ7lERtonirwj2ZRVOKhrXyIyHFQ40zymu/3f4o971Gk7DlbwUFE9yPRC/yYjUsNBnBCmH/MmloLW5isiuPgPUBs+dtYL+iCmVNSK5+ru/KAZfHAL0jp3Cc8R3m13w+5WcjSc3VCZA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715601674; c=relaxed/simple;
	bh=k5JrDD6kO9aJnux0YwQJArQrE0p+HvVa2V2MWegmWx4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GG3ITV59Cqf0pUMIRnLVK9magDjosh7SwI7w8XNcH6hmKxYBkao7kxlX54PauhvJoNQ8XYrPtZ/L+Rx5H08Lk8f9xU5wBzeCPgAEdRTV3/dE1d5y/8dbgocTuBBkuhH1pLGCLQBuF8NXvD62pQQIYSI5oiNALMzhHJrdG0r7ojQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from ssh248.corpemail.net
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id KJO00057;
        Mon, 13 May 2024 20:00:57 +0800
Received: from localhost.localdomain (10.94.9.159) by
 jtjnmail201605.home.langchao.com (10.100.2.5) with Microsoft SMTP Server id
 15.1.2507.35; Mon, 13 May 2024 20:01:02 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: Adding parameter descriptions to the _scsih_set_debug_level
Date: Mon, 13 May 2024 07:59:56 -0400
Message-ID: <20240513115956.1576-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 20245132000575056574ac4176e6ca9cf9ecfe10e65bd
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Adding parameter descriptions to the _scsih_set_debug_level.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 89ef43a5ef86..7b6733aa6174 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -302,8 +302,9 @@ struct _scsi_io_transfer {
 
 /**
  * _scsih_set_debug_level - global setting of ioc->logging_level.
- * @val: ?
- * @kp: ?
+ * @val: the value of the parameter to be set
+ * @kp: a pointer to the kernel_param structure, containing information
+ *      such as the parameter's name, type, and permissions
  *
  * Note: The logging levels are defined in mpt3sas_debug.h.
  */
-- 
2.31.1

