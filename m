Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1105B37AA98;
	Thu,  5 Mar 2026 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704403; cv=none; b=gQoWX6m1Bon2Yilqq2zqd6L13FqYCTzT/BEacZCt8nDlToDXoHaUeR+UdDep3qWmITj4b+RlyYQmWXJWp5odHmKeCz85HbRvBEu4vDyuq1yrUNRuMGh3lxtI8qPhkEY2LGYjPuRB7JDEywbIvhOJwDTo4wXCgPVMwU65YEfew5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704403; c=relaxed/simple;
	bh=2EbATVpVOVOS933kfSXsFKvmbuXpWktHfl9r0cEJlkg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O5bGP/+fQTCXJjP3dL7yAvBIw4wM+41VHnD5vDxKMQ199+gt1MeQwanKjv+nA1B68wbKWiwK0F/OqMjCe/g//VDWchRCaxSpvHUvtrFlpXpJ0hUGn+iRZcqQmYmvp8gabCNv4FdRnL0EuEng62S3HV0Ov49KGsFceErfYNk6aa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=KjnVBt5B; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=O5pn2oU3; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="KjnVBt5B";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="O5pn2oU3"
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 57F4620004;
	Thu,  5 Mar 2026 12:45:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 57F4620004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1772703904; bh=8BOuFiPdExblRaaZ6RVcKvdBu5mXJbhzUV84VWvkSrw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=KjnVBt5Bw7OpSdNpxe3JsT59rYv6SpYxzrm56HLg4a4dfRRYz9JH78MNS73rVMFyF
	 a3uGCz+iui5vM/3g5ZdFnkEtNty1BjkGuyl3MnP4ihJilUSwSgHLueaDHZtL+6wDsE
	 auex9+2paEFmRfxO4+81VDDhfUlZnV+eonGjjRBG6Dw/a+Ufer3pUIEN6S1lIHHX3p
	 EZqTucrwAyKdGMoFdgmU+PNpDM1Tt9xBP5CLuyCcmSSm7zOXvOw4v7gHqBJaR0nTDr
	 myWqed7SxIJZH7+d8A8ksq/yr6djeCPOYypnoPNP/AgnSLLXdQN1KeFq0HbloSoxq5
	 e6uxmcsDNZC9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1772703904; bh=8BOuFiPdExblRaaZ6RVcKvdBu5mXJbhzUV84VWvkSrw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=O5pn2oU3LC4THc+9HTfGj6aCbZX2rUGouZ/GzZA6GbUHcHAnX+btHfIScOBhMTZ0e
	 bdzNCISGRe2PRxdfpxmOWaQdsQjqch6x+NsmGNh7t2/mdjR8slRtaJRuSU+/dUaLDt
	 8xcUPjpWLsXc/2KEFR3Oofmb3z9v1WhrnI659yW+NhJPAPOQMk27oBi9PsgDbrYQFU
	 WttBXQl4p/CjFEDpIInucC5skCyF324XyvoDNz7OurM232nSkPhdj2Vcm6pVVScorD
	 AodADFPVMjeojxUPqfIk4YOH/dRIyy5i2AEylwJmoxo3ldosShkJgKbM9u+hW8ftqa
	 8o8+wa451xirg==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Thu,  5 Mar 2026 12:45:03 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.34.9.246) by
 RTM-EXCH-06.corp.yadro.com (10.34.9.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Mar 2026 12:45:40 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>, Mike Christie
	<michael.christie@oracle.com>, <target-devel@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux@yadro.com>, Dmitry Bogdanov
	<d.bogdanov@yadro.com>
Subject: [PATCH] scsi: target: fix default complete_type
Date: Thu, 5 Mar 2026 12:45:39 +0300
Message-ID: <20260305094539.5721-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-03.corp.yadro.com (10.34.9.203) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/03/05 08:49:00 #28252152
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

There is copy&paste error, fix it by setting the actual variable.

Fixes: 06933066d88a3 ("scsi: target: Add support for completing commands from backend context")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fbc8ab65372e..9db2201aa553 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -813,7 +813,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
-	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_COMPL;
+	dev->dev_attrib.complete_type = TARGET_FABRIC_DEFAULT_COMPL;
 
 	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
-- 
2.25.1

