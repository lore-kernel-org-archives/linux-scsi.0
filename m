Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794044204;
	b=N/C8NwDJ/46FkJMqO+lUXZ0Iu3+YBXzUCElIbqcWxpdgCEfBC6pWTpTVjd1hF6pPxw68
	 y6eT3b/BaahbdJatoDVM62ZyEf0hlMPAJf9OJHsxb7HSDtpfakxe3HZ7rI3V/+S5F3lsj
	 ddI5j5ytmURE2djnybW9VzVZM0EAyHz/H5i8ATiQIC8J4W85l1+kAFAWVxN5C0Xk0ZcJ2
	 zg+PZqhOeAzAY7VII0E8jgfDUOfGtJTkCAnxo0HLLv6Tmb9E0iJSD7ohE5feLZ+VdQcGy
	 DEN5dw37rRMWU1LBFYEyAjFnXoVUwtfUSvEqOE2rmMKElFFpdLppuyvNMeMMxUmkSfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794044204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lYMGUU2CIUg2D/sJH1ZfexvtxFBIZgq+4u/YwuahtNM=;
	b=1AjyisvzEu/EVZZQlOBtKC8yM2883eafBg5tleItcbOZBmmhK1abGXdYkjwUGMXblX7D
	 zge5hz6xAEtU9SDOqKYyxb0k7hjaMOGxl5R+tlJK0Li36pDkXa+fkzM0MQd2lR5T3Josu
	 hFJwZvxyXYsRJUxEuoynsoiO/sK2vmglsY/eXYcaVweQ3LT24T8wdmfPrEL7AEnlzyGPV
	 2PY88ZCfILHBu3ZkXe00V3ZAZ6zjajEEjMqm+ngrEY23wZhp440GfS2V8DrrCnLo/mDro
	 ZHjceh2KN2bhOVT6YJwP5Re4qZVCdg64zSl98dB4nvhlZrJOtkGa3Zz9iU7BeIx1DNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNTPPUbl;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41870606A326
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 09:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41870606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fNTPPUbl
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2230186eec.0
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2026 01:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794044202; x=1794649002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lYMGUU2CIUg2D/sJH1ZfexvtxFBIZgq+4u/YwuahtNM=;
        b=fNTPPUblkm+ze6yDmfRu4A3WkIwa0RwHtg73bpPLPYy6PTkenx+898Wpuu6duwCnid
         JDKlmv7dSB+aLXnhgwzFCvQNTN11BvFPVv47eFO8YtsU+YJvLgRAnJ07I5rC1nRo/Htr
         B/UnC9FUo6nQejx8DUIgwLPFMFo2cdbjufe+VuD/6WAWr1+CrmHDdvUOa34678vUBbQv
         CtrWJ6PxD+0lAzUf0MV6PkYzS1gAJfd6UrSkE+C0VIzecS6AClY0nA1zmmkeysaE5ANN
         oQDJkyWRrn8jIwHX/KuuiSxu3NcThoyt8O+9JPiuXhjbrhjyQBlGVdgEIFLNFJbtLS0Y
         YW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794044202; x=1794649002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lYMGUU2CIUg2D/sJH1ZfexvtxFBIZgq+4u/YwuahtNM=;
        b=Hdh8a5khvueggN82W3Vx9dvT57/rjRRRrASmLofMheQk50meptcy7Smy+e2PwJRSXV
         ceJ1KAo84mTqlKVCXF0/0rjBA+llbR0H2cSj8z3oeHpehBZVyjXExrvujBllVnpCvOSH
         fce2mcXUs7UXE5+GqOfGlytCFyp7HT7JVDUyuIevN0OUnJfSRLvHSXlM+J9A9hbne1hw
         DP+A0Xtpb2nR5lUA6rAW/nLsGVJH2LGusox0Isoj0va8+FS6D3Vt4oH0tarkZAesaUd0
         uVqka/LyaOGsV3519DCYXJSkWhTEOiP3mKnePWsHvgmRU/9IdLViTCb0sOtl+XeS4Hmd
         Hhfw==
X-Forwarded-Encrypted: i=1; AL+hErFH3wLH+2rpZQBegnkHCBnMWOhOBtFBm3LMwSICP7E5Dt6pKXfan7F9ofK+ucV1MkvMLT2q5vEsqpai@vger.kernel.org
X-Gm-Message-State: APuU4Z+L1abzL/BcSzXh0zY4w4VRoCUPSIPVhYj7kak5C/YZm6+gG2oK
	qXOoY6311V//l58eSVyDzt4g0PiARGUxV11epAOmEWnfo8GkH8fDtHjuoPiOPMd9
X-Gm-Gg: AYBFou04u+K0Z8/HcsibUKCd5QhCvuWwZ00KbzMXW6V4uFZQ5IvIcyyI6MoHpZzRSd2
	vi5panK851maNtZZzvIGaFx4M34GFf/DBuv7txC+29/JJ7DNP+Sw+ffvW6yFKNJ1vTd/96f5iUI
	OAzfPhZyve1l83mCgoFwVK1A/6DkD4t9qVS4IVGK/2azFKXE7+qj/aUeero0ygKXQJpoAgu7OlS
	5Mh0ZD0VthnwjUJXHdVRzp57G99nZBSLTN44NJQyBo1IqH1tS7xywr1A2R9JXqkvrAnTyj/NtSA
	oomKAWGJXOL5NLGbnciUGyKK2Q+lWyM62hFQHbZ1GdWIfxWn+28oG5lKapA1LNN4Q6cn8hLQ72k
	8zAuebxishbzC0dIegtE9kvK6kGYXzsi1qaBosnWLbqPKMt17Lbdq1mGAmm2BHY7Y2phI8ahF0h
	DCZvTNEOCNZmnLTtWLt2DGfYO4jcdZncIS58VhNGfjxKyxjDwpb2WqGSwm3Z1/R6vASZUJY05eO
	thjFZPUy0/55utmuNPH8vnaFPYcjHwpRP5HBhr3boE6uQ08Qy/yyfwy8/D3G2fIlkaW9aHocFAq
	dqJJH7Jiss8rJF9Up4ZqfzuPHH2XrlXGMkFPch1MdMHwccNZpA==
X-Received: by 2002:a05:693c:881b:10b0:351:1bdb:e3b7 with SMTP id 5a478bee46e88-36f75b2c6e8mr6595097eec.15.1794044202281;
        Sat, 07 Nov 2026 01:36:42 -0800 (PST)
Received: from ubuntu.. ([2405:201:8026:213e:5e01:ca5d:8cda:211b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa651e6b1sm29803105eec.3.2026.11.07.01.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 01:36:41 -0800 (PST)
From: mdshahid03@gmail.com
To: ketan.mukadam@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] scsi: be2iscsi: Fix NULL pointer dereference in memory cleanup
Date: Sat,  7 Nov 2026 15:06:11 +0530
Message-ID: <20261107093611.42311-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammad Shahid <mdshahid03@gmail.com>

During memory allocation ,DMA memory may be allocated successfully
before the descriptor array allocation fails.

In this case ,mem_descr->mem_array is NULL,but cleanup path tries
to access it.

Use mem_arr_orig to free the DMA allocation of the current
descriptor and handle previously allocated descriptors separately.

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 34 ++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..95706b5db7be 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2549,22 +2549,30 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	kfree(mem_arr_orig);
 	return 0;
 free_mem:
-	mem_descr->num_elements = j;
-	while ((i) || (j)) {
+	/* Free DMA allocations of the current descriptor */
+	for (; j > 0; j--) {
+		dma_free_coherent(&phba->pcidev->dev,
+			mem_arr_orig[j - 1].size,
+			mem_arr_orig[j - 1].virtual_address,
+			(unsigned long)
+			mem_arr_orig[j - 1].bus_address.u.a64.address);
+	}
+
+	/* Free previously completed descriptors */
+	while (i > 0) {
+		i--;
+		mem_descr--;
+
 		for (j = mem_descr->num_elements; j > 0; j--) {
 			dma_free_coherent(&phba->pcidev->dev,
-					    mem_descr->mem_array[j - 1].size,
-					    mem_descr->mem_array[j - 1].
-					    virtual_address,
-					    (unsigned long)mem_descr->
-					    mem_array[j - 1].
-					    bus_address.u.a64.address);
-		}
-		if (i) {
-			i--;
-			kfree(mem_descr->mem_array);
-			mem_descr--;
+				mem_descr->mem_array[j - 1].size,
+				mem_descr->mem_array[j - 1].virtual_address,
+				(unsigned long)
+				mem_descr->mem_array[j - 1].bus_address.u.a64.address);
 		}
+
+		kfree(mem_descr->mem_array);
+
 	}
 	kfree(mem_arr_orig);
 	kfree(phba->init_mem);
-- 
2.43.0

