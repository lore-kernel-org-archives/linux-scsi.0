Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174946;
	b=h/2BgBfRwYk6Bt6ZWWJrRlZpONI0VP9pRI8VnxfEc+jwkqF8qU4Q78RYftpSLIEMu7sa
	 1k/QvI3GFjJsYazPsRKPBd1sCDdNMtyqYebYVYCRTblXygz+BoPI195/OXaOB34fqur4F
	 Y9RKeUjsE/F7JxcSE3dbsf37/VGXQVT9FZHAYjP1QMMIimOvpL4wMuCN8GqRNv5xMuKgJ
	 M0NA8o785+IS3YCTRGrwmYZwrICHZknjMPeswRjPZpciK+E35CxscCt10a+fyWv7M4gH1
	 SoetGSKjF8CKTiMRwJvd7Y7S4S24+V8nq9ySwSTFNbgss/S/Qr5x+G1x/4OZGtzPPxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
	b=gbud4BUuV9oihENvfNDRwG+CUBSA0bp+knAjGrBtzHREG96kZS4JyUXHbveipIwFKSo/
	 GmK4pmM/fdmUA/SWJVeIPbPAzLFIxQ6D6/fG3sYlI00cCllDolwEASA2XwgwToG4GQdyl
	 mTU1ebEUVn3xkdM1xoUDpuOKVH+X47Jey+RXLtWHghMYQFX6/sam9Ao75joPzCc8qzgua
	 nresHmGOyGN4sRArxepBaW16qHv/ip7VonYDM6OhNjEtHY9YEaZYdtGPqkzP3bALoTptt
	 qhvvzlENo/UcFC3ZtGS7+jSNKZngkJr4CaZm09gGtBvXVUulviVPtJRIBqtmQOVUmwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Qnc3ovur;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77663606A331
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77663606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Qnc3ovur
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so509451a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174946; x=1795779746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=Qnc3ovur2XzIyk91JOuf4a9IFGgaBu89uCIW78Zz8dXebNk+k4gvcFpSUeRSxBKil0
         1hxBAoUBA9rQSxY9iU9BftiIKlavOxTMEPsh9ry0f5u3gPbiy2/HEIMxfZXSwGd/Nsw7
         woVTcMoufsTydKmheTN6n+xhboCjh4eqalJEtyB2YcsBmIow2d9TZSZerajcGJoS2tPr
         5Eeg7T6r9Uhj4w6vsCJYyY/QYusGkqMX8i180+0jzZ+XVaj/9sA1GP0USw7R+jqWZlCE
         5LA258rfH2T47oMz6BdFlEnQY0TiNoJiY9owEs6jlayfJYfMPIatSFQPcS3zTm7pI/+d
         0qtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174946; x=1795779746;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=UCPKFsaBGush8Ms3QCZ17y2Bw/SivG/o41JCTVVFR5/Ei0UWpga1WM5soVfQ30f6n8
         r4DU5BqGxDBZ5rUSW72I0vKMRfSeHhxVoT+EWZoF/NPF86c9J2Z7CEIrT2kddmjxqrWX
         99FeBOupPcJHDGisimkLGdsSgKcluuJGIYBWFOb3KRYsQ9jKJlyb1D8gSWK/FpV071cD
         EyKyez6QhgySHNmufU9PfREh8Oxc1WBDSZ6M5rbSpNplwrWLun5RMXbTjvbZ7ZsGBRVx
         O7hZdE4y4he6rXfcsZ7l+6TZ2UzsKFQ0A/3ULhDXl8nJtLUdH901HOKK+UrYBitkk5TI
         l11A==
X-Forwarded-Encrypted: i=1; AL+hErGEW+O5ROA1ZOyVwquLVTWlPejCETKAV6w+HoPbqc627JhgAUcExVMVrLNT4YVJOk/G0jM5oaOk/5CB@vger.kernel.org
X-Gm-Message-State: APuU4Z/tiX2ESvFU9u5v+HKE9MiMt6dd904vfQcE1Tl+zlyqXigxicSk
	qckkJzfL3kjIg6YiMCOMEl88GekAFtQgGppwJ9EbkwMqnlu5/wodCazdYM/H4QT5SHM=
X-Gm-Gg: AZFdTZdtf3Cmve/2/fiIBy/S0OHUpQJc0CMP+mz214mIezPzTOtLKYnb+l5bPyavu40
	sW+NLNgvDDABJdBZ45xbEUlYmLgxzE4vwfwcHojIoeb/yTUDiXKHljzu21a0NUMueYBiaoBq+mN
	wW/5/Isjfsf/tqxHqo0ObpWxQyCbCtrtUEx2UrGKgnRvjhjRGn1jP7/ubdzDJumI4G5R/pq04a1
	u92QQ5ex+qjcYe93thna9n0OjBzC2FSybtr33BSAOnmME6WrbsN4pgooSQSywsxbhNAdbcIsCGv
	FmDMsuoyVHYg2AXvWxqtuXUQEseagcyee6fKiON8XOL5WApizMYZjw6oE4JBQbtEydAV3YzWsJn
	hvCOuYvGZatAezbAm5uP23gzdvXHntnfK6M+/eD1z7LthXf2iD8FISQurZ2+CqQA5MdRsZ88rhi
	RtsUcArpa+qeA97SlkQeUdzsRlFxg9N6DpFFGUUsrKxLHFHNdtxWDywRTu9H1PewrkL9zDGmtzf
	c5merSfeIDb3GtykR/QSeNuWVsStjCtLdAupKQKxtxxpFUrWS+kkCbCVBb324SdQNiz9HALOlFU
	SB3tDyZQL4KLd7aTB1lEksDKq7hRUPIYJA9Tg9zlfMte6tdKVqFLy8stW+IlKlbT1T17iEPsrII
	t5eUf1vtoGR2Zqo++wc5HHcivFp81SJ/Bv74a
X-Received: by 2002:a17:90b:4a48:b0:3ac:9d14:fe9f with SMTP id 98e67ed59e1d1-3b41c9032b4mr2584267a91.31.1795174945866;
        Fri, 20 Nov 2026 03:42:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm4086815a91.6.2026.11.20.03.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 20:42:20 +0900
Message-ID: <20261120114220.3072138-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007032501.640372-1-yhlee@isslab.korea.ac.kr>
References: <20261007032501.640372-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
