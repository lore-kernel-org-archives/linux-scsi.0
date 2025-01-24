Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD1A1D61A3;
	Fri, 24 Jan 2025 08:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737706493; cv=none; b=kQUDF9VcpRd2xnIwHuj+bUmeoG47B4uqTsaFnAgMBkbxIBY53ZEQ8rI7s+pt9ddwXAwNGvZmtLnI13BawLX2R4o21zPMiVl3FiRVB6ceADWolyLUPvGUKRthr1F3u+M7EkkoYz9TsYFIDXcjn+p9CXYrOFnZul0xrGnL4Gpghe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737706493; c=relaxed/simple;
	bh=MD25qTp2z+CdtaSbxA3TtbwM8lTY/olhUkA0W00MMco=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tW3vQ+mu0zfUs7Tq/RvLp61dTlcSNf/tykW4PUrebIEOJzCaioUrh/zEz0w2BUKQMESwqBwZBv9F6adY3cMHFhlLjXgQ7ObsEDUxS6dSHGUELeauQFJ4v83ViBujoUO8y2rtWdE9lujeO+az3OcRtj9lMreUqyiW22CGzuBMawM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from ssh248.corpemail.net
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id WBM00131;
        Fri, 24 Jan 2025 16:13:31 +0800
Received: from jtjnmail201607.home.langchao.com (10.100.2.7) by
 jtjnmail201603.home.langchao.com (10.100.2.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 24 Jan 2025 16:13:32 +0800
Received: from localhost.localdomain (10.94.9.245) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 24 Jan 2025 16:13:32 +0800
From: Charles Han <hanchunchao@inspur.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux@treblig.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Charles Han
	<hanchunchao@inspur.com>
Subject: [PATCH] scsi: isci: Fix double word in comments
Date: Fri, 24 Jan 2025 16:13:30 +0800
Message-ID: <20250124081330.210724-1-hanchunchao@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: Jtjnmail201618.home.langchao.com (10.100.2.18) To
 jtjnmail201607.home.langchao.com (10.100.2.7)
tUid: 20251241613315ceb5ee6b2fa245d95cfd47851a992a9
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Remove the repeated word "for" in comments.

Signed-off-by: Charles Han <hanchunchao@inspur.com>
---
 drivers/scsi/isci/remote_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 27ae45332704..561ae3f2cbbd 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -198,7 +198,7 @@ enum sci_status sci_remote_device_reset(
  * device.  When there are no active IO for the device it is is in this
  * state.
  *
- * @SCI_STP_DEV_CMD: This is the command state for for the STP remote
+ * @SCI_STP_DEV_CMD: This is the command state for the STP remote
  * device.  This state is entered when the device is processing a
  * non-NCQ command.  The device object will fail any new start IO
  * requests until this command is complete.
-- 
2.31.1

