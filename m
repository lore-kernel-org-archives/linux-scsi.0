Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA15B1922DD;
	Wed, 16 Apr 2025 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744762980; cv=none; b=VgUY9IkyAZpZJ7fMuB7Rkf9xJIqa3p5C0sMUb5WdC7shZJ3IIkd1MIwWQOx/MUnJIY/Q0t27K7lfYhYCH6OgyBQp6vAhzD6ReXD0uT5Petf0meSwQrXHDQ2qjHuWNarul0D1LYH8o3OiQrxbnD3gfg1ie8OO/u+Un8mpN+00vkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744762980; c=relaxed/simple;
	bh=eqTSVK0fJb93nGmyoukDCWFIAgXFKsNTr2iOnbl6pms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ce50QFKdRFQwRWfHnwVEQEqLQaCv7UVMdazNec9Rd0VeGg7j9kMH/7xKYtCcOj+b6kjREeUqGzd8DhuvAEPcqQ8RwB8jahha1s2ZkRPO+bDF0WOBS/nRPsj+6JdVKD1C98gceutUl6BkzGYerq7AHl918RfjW+ltoEsc4hlaVAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=AgUT39X6; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="AgUT39X6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=eFxO4nceIdBdEGm0H6ZsUqRPhFyxoqg5KX+zbJw4bnY=; b=AgUT39X6WbB1yxW7
	nSg4FDkzSUA8Sgwd0XwG6xkDpgPFJMqtfgbmonH2/ryud2NYHcISMgOXBu7Ja8941GwE8r9bmHtf8
	mDMgG8Kfi+GLCspIE+5Xxu2mII3YRxyjA6s91ZQpbGTQEPPzygxh+T2PDoP3prH3FxsFc/pSrjZZs
	WdY07EGTBfC4x22dhyJE9T7hxxzxej7lZvfdFVVmbooReUi9rxl8ARobLwdSaZ7UJhtOiU8a0czec
	efaJE+yaT7rZGHntAzRe82e3Dbshvn3aKkmqsbOpSRLEkOkgG9z77H8/cLYAscWWrueAgwjM1aOB3
	XzGdG4aocNxl2fO02Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4qY0-00Bl42-0J;
	Wed, 16 Apr 2025 00:22:36 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/2] scsi: qedi deadcoding
Date: Wed, 16 Apr 2025 01:22:33 +0100
Message-ID: <20250416002235.299347-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  A couple of deadcode patches for the qdi driver.

Build tested only.

Dave
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>


Dr. David Alan Gilbert (2):
  scsi: qedi: Remove unused sysfs functions
  scsi: qedi: Remove unused qedi_get_proto_itt

 drivers/scsi/qedi/qedi_dbg.c  | 22 ----------------------
 drivers/scsi/qedi/qedi_dbg.h  | 12 ------------
 drivers/scsi/qedi/qedi_gbl.h  |  1 -
 drivers/scsi/qedi/qedi_main.c |  8 --------
 4 files changed, 43 deletions(-)

-- 
2.49.0

