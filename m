Received: from mail.crpt.ru (mail1.crpt.ru [91.236.205.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0819ADA4;
	Mon, 21 Apr 2025 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.236.205.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745234794; cv=none; b=UaLZHRR87X+jVgbAvyEak2dQkoJe8eNxlwu0rOqTwfMVQhL/42yARBKugbykexpKsQ5g/RRjtptc7CqzP3r75aPgcLs8MOSp49xF+8T83RpGtpBj4KWQEzR7MmSMvrrFCe3H4eGZkn+eczHBOdBlhZvwYy3T7SsyE9vpz7M56TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745234794; c=relaxed/simple;
	bh=S1Qr1gUL5Ck5kLLsTAgil/EFoYS6KR0lLR9WWXA4Jh4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pIU4Opw9KvDii/1sheHVRMAsoeyLtZfm8kT34wK6LBUBo5lLPp/QveKNTsUdor7+Cy734jq159BxAsM6+xNiKsKspbjKMedvCJBUYwlVEF8jPa0ECOD0orMXS6q/zNyVSPNFkBxGQtASTRt7bRvrWuUoRCyolFJBt0tLJ/k/S/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru; spf=pass smtp.mailfrom=crpt.ru; dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b=ZDOdYN8V; arc=none smtp.client-ip=91.236.205.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=crpt.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=crpt.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crpt.ru header.i=@crpt.ru header.b="ZDOdYN8V"
Received: from mail.crpt.ru ([192.168.60.4])
	by mail.crpt.ru  with ESMTP id 53LBQCGS005968-53LBQCGU005968
	(version=TLSv1.2 cipher=AES256-SHA256 bits=256 verify=OK);
	Mon, 21 Apr 2025 14:26:12 +0300
Received: from EX2.crpt.local (192.168.60.4) by ex2.crpt.local (192.168.60.4)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Mon, 21 Apr
 2025 14:26:12 +0300
Received: from EX2.crpt.local ([192.168.60.4]) by EX2.crpt.local
 ([192.168.60.4]) with mapi id 15.01.2507.044; Mon, 21 Apr 2025 14:26:12 +0300
From: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>
To: Sathya Prakash <sathya.prakash@broadcom.com>
CC: =?koi8-r?B?98HUz9LP0MnOIOHOxNLFyg==?= <a.vatoropin@crpt.ru>, "Sreekanth
 Reddy" <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>
Subject: [PATCH] mpt3sas: Check if the variable 'nr_msix' is equal to zero
Thread-Topic: [PATCH] mpt3sas: Check if the variable 'nr_msix' is equal to
 zero
Thread-Index: AQHbsrAvDsbOz89l6UeuBq57+fZEBA==
Date: Mon, 21 Apr 2025 11:26:12 +0000
Message-ID: <20250421112605.97897-1-a.vatoropin@crpt.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-kse-serverinfo: EX2.crpt.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 4/20/2025 10:00:00 PM
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 192.168.60.4
X-FE-Policy-ID: 2:4:0:SYSTEM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=crpt.ru; s=crpt.ru; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:content-type:mime-version;
 bh=chiOBI0NFnnFyHL+6QC07jGgZAG31p2S9fL2p3s5gJA=;
 b=ZDOdYN8V3cxXoTMVVjCd612smaX9GrTi+F3tbkIRgh+R2lM5mJV9skg2sdO6QwlLJDTNtQBbWDwZ
	8meM5qkAVjCHFVvjkfM6RaWHBVKuBvJ4InImUEIQWm+EbYos0w5HZwyav7iqw/ogF3P1SUdQXQoN
	Ys914/Fbm3YcmRCoiIfFS4HXJsjm2A+3llPtGMNKvkf/1opo4hpCO9hx8Ua45rGqjOTH6xdYEc4u
	xL/0uSwAHYkQF0gEXUFGhjQRDs/v/M4OQKWiJfFKVB8O9fjCYMsqMqDtY0c2neQpLryuOqXNDmvw
	qVXoufiyc1UQd2h8k5l4QQx1I+JlGCNCTcj8wg==

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

The 'nr_msix' variable is checked for a zero after it is assigned a value.
However, this variable is assigned a value one more time later. After the
second assignment, the check for a zero value does not exist.

Add a check for this variable to ensure it is not zero in order to avoid
division by zero.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
      =20
Fixes: 91b265bf0b57 ("mpt3sas: Rework the MSI-X grouping code")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt=
3sas_base.c
index bd3efa5b46c7..f9d5c3bfba53 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3267,6 +3267,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc=
)
 fall_back:
 	cpu =3D cpumask_first(cpu_online_mask);
 	nr_msix -=3D (ioc->high_iops_queues - iopoll_q_count);
+	if (!nr_msix)
+		return;
 	index =3D 0;
=20
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
--=20
2.43.0
