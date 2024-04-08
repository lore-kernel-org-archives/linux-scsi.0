Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75E17C2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 02:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544872; cv=none; b=hCRWFuCmnaOVAQljqbFrSRv55CXqkLW1jRJ3JwNA6UNfRyW3L+dKC8GzO4QgCvZvj3cVutba6pDF1PjUe16jLdDY83M4ONKt5OpYiuNlHx/5EKPL75IipmuFMCcuGjxIfPwjmiH0s83Rr+dHmreeX2Kkkqw2YyLgmXdIRMrRgFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544872; c=relaxed/simple;
	bh=zKjb/jPCMrQwXReBlD/nI3Zwb4e2eiuTkP82CQHSbXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwklWOUgPbOSQjS2o0E2v2LvZyk8YMpDu4RyuvltMQBStEmBv2fNTI77o4uktkk06O6A/Ic5cT2XgaABGtWmXkIFONsusjvvx5oLTbzxGjxSthb/DphsWalQkyVilPp4meaz77xneXWW4k2aq8hRLqOAjAWhNfQcZn0f1BSw+gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rPzHZnSb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rPzHZnSb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Uc5mqXNRr9J9NGsmtDt/wAh7o+QREKqBSBaqbFAcKUM=; b=rPzHZnSbVWsUdQgOlvhIpJNmWW
	uDDNK5D2kquJPl9e7nPntyvMZd7GuufN6dFKt70Qp6b2GnhwN0awQiIkLM4AgBsKaAtzsH476yNQ7
	lSfDVR3XVCGF6TB3sLwhP/44fGf4V39cUtUgW521yCWU1QPz6jnop7GzoVvU44Js96MTa/zT0I44J
	ob9QtFwgqFc40XTquzCpZ0zHwXYg2GeXaIYou1EicnhhUjfOIjB37pChura1zgaTDFwta8wL3ssHd
	pQSUdVajn5zoUFpy0511Ptu3y/pIUESNZGLgsl6XyoDrwMOq1FW1dZNsl1dcNrhRCFDDDwDP67Ep/
	1BfgtxQw==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9R-0000000E7aj-3plK;
	Mon, 08 Apr 2024 02:54:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/8] scsi: core: add kernel-doc for scsi_msg_to_host_byte()
Date: Sun,  7 Apr 2024 19:54:20 -0700
Message-ID: <20240408025425.18778-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408025425.18778-1-rdunlap@infradead.org>
References: <20240408025425.18778-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add entries for missing documentation to prevent kernel-doc warnings:

scsi_cmnd.h:365: warning: Function parameter or struct member 'cmd' not described in 'scsi_msg_to_host_byte'
scsi_cmnd.h:365: warning: Function parameter or struct member 'msg' not described in 'scsi_msg_to_host_byte'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

 include/scsi/scsi_cmnd.h |    2 ++
 1 file changed, 2 insertions(+)

diff -- a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -353,6 +353,8 @@ static inline u8 get_host_byte(struct sc
 
 /**
  * scsi_msg_to_host_byte() - translate message byte
+ * @cmd: the SCSI command
+ * @msg: the SCSI parallel message byte to translate
  *
  * Translate the SCSI parallel message byte to a matching
  * host byte setting. A message of COMMAND_COMPLETE indicates
