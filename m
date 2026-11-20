Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186880;
	b=hIyKfiW2n1estWDx86rvCw6Af9lFF2Y7I7A2A1RAMG74MSz/H2whqPPq8velyFeKK+Rb
	 O+0gJtr13uM0KGlRa6hfSI24fWS9nCz3M92FhvECxQD5wpSY4HeVl7B/P8A66FvjLDd/b
	 eyXaWgaSfTeBRm1jj8MjfinVWFHO/HYfGx5WsdOJTwVQT/Jc5aZJ5DDosPEO3pyoiE6y/
	 u0tsM3hfa2XeH8CJwfXf7PKqI7834itGo7wk8wUwjm4CX6wwguGSVDfp1QDF0tqIAgYu/
	 FpYSuDTrlMlHGY67dsYC7iAVt9jmWD8Khh11ilwshjTQRjj2uvL+Qgv90MIPYZsz/yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
	b=VpMtJHjyn2w0jZUQPvhzu9eXEKwR5HXqxCPVa1YCIU/UTmiOzbz0+//AY2AZVOUghtaC
	 ryeXVmp99AjHOodeTDrWTmI/CZLuNl4qR6E5s1m4dknt8ZL6sKZHyKm2Q0HyTEcyLRUiW
	 u41qVN7EjZHr4qiIJOpL5oSrZM/a5rGq5A1TQ29axg16uwGBFHX53n+1nNY0YsffeHUDG
	 RpTYVD6cMPOXeUZOnRIsYjFvCx3eYuboMuHBufjCFtlWYO9tfjwxig2ZAHqKiWSyTYZW1
	 /6+NmCbp3qnDshkGZKFi192N+V2zcbl49KrFy9NWGEH+yaHn2e1xrNI/gXXthXRzR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JvSz+61v;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5F60A5BC8
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FD5F60A5BC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JvSz+61v
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e9d7791b00so8869445ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186880; x=1795791680; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
        b=JvSz+61vQyUZqYJyiTfG07ysQ2zpBtbFrcR6lmftpISADf4xgS1s7hF9NFLDmqknVj
         v+x2IBguo7+M9xKQdefS1WSvzXB8KlfUg6m4NwfgrkWKs6lRk7XWHNTrXg7p4MvZOfQT
         yDhMmyx7P84x5WEU/WLZg9UBxV+gdSGQhF1Ykww4UyHSIfTmqWdpMjzzX/HQBCByoE6l
         /8dY27abJx6u/+GSsi+24FRWophKKvPATbynOHgbL/XlxfG2iTOfg2S3xSvkC31ay1r7
         atGPb68ZBnLSOt3keQPpWiK6aEr/sMsm/KaTAZGOW9jnuLMkVCIs0uTQTfQqaj+ra71T
         WfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186880; x=1795791680;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
        b=SAGMG3ASjJ2RTMgM9mN3jaEDjXD8BU71NamYdkUqYaEkUdsrF8RkCAHbTHtUhNu6B0
         vs/g8KfvSZ6xzLfv63i5CBC2+1L9pdf9vIt8wC0lpx9anIiLO9ekdx3m307pRVnfgdmd
         eVZnVAhwjOWpciqD2X2UZBou7rfPCv3gEp59pSUPIov/IcWQG5TpH97hicnVWgPJDiO0
         VymkH8xWd48Kakps3VlHBHz/IuMjI4b2Skk0mV+xLdXgQhsk5Eq8vgO1KTyq38VNs54Y
         LhmGbpBRtEzPhQSRgW7bGuPG2bM3ycfQjG3iCE47q9wbLSvPhOnmQ2S35y3xm1Fnk/FG
         mAuA==
X-Forwarded-Encrypted: i=1; AL+hErFK9Gjcz6NvvHvAY+ETs2oH+jYC+7B1BvGWlq/loYK8wh92Ap9bu7VXhZEA7z7bv3CY15zN0olb+2MT@vger.kernel.org
X-Gm-Message-State: APuU4Z8m9OpPcuUFISFL4CZa5jH2FWqoTE+O9iECcnGpApvNVxGuK+eE
	mh6VQcoTpNoPRd73fYd3iYUQmVSfg0W1tdgOBmEQVZfq388ElpLlAmNUGszfseQkmMw=
X-Gm-Gg: AZFdTZduuVcd1UL0Q85F3rDm3EtGDzTsY8B1kZSeirgD3Gc9hCPcHAo1PhJbRKla1E4
	IxqOkEAS0Z7ijNsK1NfdGBqjxux6LriGOvteDsZKUpxMsb+BU8zJXMQoTHjFuRdYmEnv5sqhf50
	3HKqEKs4+sZpZfp+OLMr4Mo/EQ2oNQqBv02QYntkfSUF+OyEy6nK6/pCwhkZTe2I4EKkrPfWEsi
	JboT8AjuA+vvvgxsS1oeoUI4PYjWn304rcaC63rRIEiCVBQKcerHJM/asHDspbZWiCW8/dE3dSP
	O/e+XqcwltFebBOnH7pNvuQNIhHOWWcNMHPzzBx7jbG/0Cuyj0m/xpLffJXeTjQ/j8oCnjHUHXw
	IFvezYhPM/JQDiy3g3lUXe2zCEFIEwRqwXYXFOPBIsD4lsRuXCnwdbXzeH1KN5ndbKFHa+zzzR2
	U/5qZUBnOT8Vr0kGcis3tlTincUQUjXAtDv+762lZqAkrfu3S8h2tOD1SzYTpPBmrkONJwpu1QT
	YzZuyIq0111S01tzfOI/rJmUUoror5vSGwWE+YTpvFMNMziHxbVh0ZnQNPX/aQwuQ+as7lWeRR9
	2OaxnLks5m0akc4TeCC3VC98uM3ZqmBRD+/4XOhmAux+Ut2zbM8gP7NmtTRwJLkq1iKhz0S7vRq
	3qRX/flinYdeJTra1uTM6TUBiiGlpZwqiMjLI
X-Received: by 2002:a17:902:e551:b0:2ed:ff4a:6d21 with SMTP id d9443c01a7336-2f03f1beef6mr33867465ad.73.1795186879777;
        Fri, 20 Nov 2026 07:01:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f12028dsm15024705ad.60.2026.11.20.07.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Sat, 21 Nov 2026 00:01:14 +0900
Message-ID: <20261120150114.3128328-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
References: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Oct 21, 2026 at 10:08:02PM +0900, Yehyeong Lee wrote:
> efct_scsi_new_initiator() hands a bare struct efc_node pointer to lio_wq
> and returns EFC_SCSI_CALL_ASYNC, so the node state machine keeps running
> while efct_lio_setup_session() is still queued. Three things go wrong
> over that window.

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
