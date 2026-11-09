Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195507;
	b=iiKdmBOLz3oi4z8OH+R+BgId7PSR4UoKBte2T6aZIT7eQ4C5Sjhzx8ffRo01mo33Fnx0
	 dbAIkFgppeW2+lfMNKkR7QGyNTyxKaiP3hxPhcxaJUeXkJnhyuzJn6dwohNbJ8PzXgR9P
	 4Pame+mRUKt9OlEKB8b9Nc1Cgbn+S2s9C5jEEHQzOh/j6XHnCc4MZ8mlp64iDBeVLmdJj
	 e4aC+7qrI5yX23rRqZgnNLPoAu+pNsV0U0ZiRCGSzNZ1xM5GpxoLzfIQUQ0uoj+s8UYxp
	 XyGuoyD+iaP/3Ion95tgv13g1uSFoWWbwy+PEfY9mPRKv1CccUFyEapDcDmUodGcAxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195507;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=bjmpd2GsLVB9bI9oKuc5xotaF+hmV+/J9JTe1SBkGe4=;
	b=LpeWKpZmXkMByPDNh14gmj1oGnf+W1+jO8jLaMHGFCxGl8IFwjQNCp/1VY8ZSn33gbsU
	 2s4OJcSWI1tU6zL4EAsaN/Z+9LjHWiBWGLE6/PjFLbgrkWyW7647HsjG+yLrFp5iEXyU7
	 JwZI32lRq9wDQwcU1mtwVeBI6qyFc3MGjJv9F4HlYOtfFySJ1mG+UMv6/t5o9CFgq/l0L
	 VZ86QaFkkBeaTTDA1u85SCS+dsY25z2ukIMaMa/TsAvziv4JeDgIk121xDpJvxx9uOeyb
	 GHN1kQ3ztiB6VjpUwDSFFqB+TAmALiKszAOq4gTi8sJrvKFSJwU9sfzndFi3YSZoUfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=itdM0Tu5;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14F7606A323;
	Mon,  9 Nov 2026 03:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E14F7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=itdM0Tu5
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jNFqX16SSz58fdG;
	Mon, 09 Nov 2026 11:38:16 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794195496;
	bh=5c/92VOtsWXXbGQih7pTvetR3SZsjmzamqI04YkK4t0=;
	h=Date:From:To:Cc:Subject;
	b=itdM0Tu5wcHA78l5hQUwg3J4MAOA2zxW5k4Y5dKwHrDDlsVdrP7LlPrceMfuAdO3/
	 3/NFW8VGNQzMcmKp+CuX9PL1DmEYKOU8GEL4ys4s3EBuijZeNdWMc9F5guD92vz5kC
	 yE2mU7Mp00Br7tjn9W83MWr5O2H70HEzhp5TkTz8zqfOyjF/UJAoh1sGWKMLsyO/ms
	 8VBHxu6QPqXLkZJFGjr45wfgy9yrXXi08iinTOZi5SSSNzZGsqOs686c7Ce81/3HvX
	 53U84kzWjFfPUdHch7mW0fhKa/0bltIIy54ddkWie+Db3rPAkixMnBO4uedlYytJ8z
	 AWuGyTSR1181w==
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6A93c80H063932;
	Mon, 9 Nov 2026 11:38:09 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 11:38:10 +0800 (CST)
X-Zmail-TransId: 2afc6af140227ff-419f8
X-Mailer: Zmail v1.0
Message-ID: <20261109113810258gK5WuYWQKt0HsI2ikxmHo@zte.com.cn>
Date: Mon, 9 Nov 2026 11:38:10 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiBwcm9jOiB1c2Ugc25wcmludGYoKSBmb3IgdGhlIGhvc3QgbmFtZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A93c80H063932
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 09 Nov 2026 11:38:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF14028.000/4jNFqX16SSz58fdG

From: Shao Mingyin <shao.mingyin@zte.com.cn>

scsi_proc_host_add() and scsi_proc_host_rm() format host_no into a
10-byte buffer with sprintf().  host_no is an unsigned int, and once
it grows past nine digits the %d output plus the terminator no longer
fits; use snprintf().

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index fdc355d783da..d1f474c28720 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -230,7 +230,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	if (!e)
 		goto err;
 
-	sprintf(name,"%d", shost->host_no);
+	snprintf(name, sizeof(name), "%d", shost->host_no);
 	p = proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
 			     &proc_scsi_ops, shost);
 	if (!p)
@@ -260,7 +260,7 @@ void scsi_proc_host_rm(struct Scsi_Host *shost)
 	if (!e)
 		return;
 
-	sprintf(name,"%d", shost->host_no);
+	snprintf(name, sizeof(name), "%d", shost->host_no);
 	remove_proc_entry(name, e->proc_dir);
 }
 /**
