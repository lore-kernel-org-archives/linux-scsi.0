Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186734;
	b=j6YEOxSJKPI37+E6JRVhgdRxJz20cPY/o4gjRPRbb6EzGZj0WX3UAoIT6iJ5/Gwj4GhW
	 GgIn8ct5IUI08t8DpNT8ykdC25+XNN6RYnfwMA0hvexb6ge12cLn6/ESgX3owXkfYkBeS
	 71Es+/Z44TudW7gTv+ntfOWRtcGXKCxcS3mcPzVtr7pAnUFcwl5C4AiZPEzUADM43dKE/
	 JsAaqySHJ6nWFEPsDU20DGMhuilnBcfrYPmUdA+GPFp3wE/Pyr8w5b8QpcZS9SESNs/Sx
	 1UXP5PQiClgKPGM2Q8YvE1TFcfEXGGUCpypfrvcn9/9tWay1LBz+EvmjljvPG1ocW+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KxUI+6qDcU/AIs3Dad66GtLz3B3FQt8+aPt35cEovds=;
	b=lat9kSX3xtXefcGe4n3utwan5NO4OXWWInNzoB+d8n5ejRD0Km4lZqo8nhCrd1WVzFBu
	 JoMHTYCep7R+GNXvEsFI4whGljCGsAHMjaThQxMYsj5yD/JcwMWW/fMVCI/k2ZUWe8NSg
	 b2LRg7oE6TR9PE3v/56l004dHHE9T52VbZ4UbyeG7l7TGb2cL9DjznbFggwIbLJe5Q1Kn
	 Qq+nnKRnr5u5Im3hEZr5M38r68Hp4JPqPjZypo6/QT9Dkr7lzTkkVeLoCqBPUtoE7Wf26
	 ygHZFMqWXKXt/gWMBQR1eun3wll85ZBhdL8nw5u10OM3KgAAVqjS4ViBAG4K6Ttg+og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=i+kXuQkI;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B460A5BD5
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:58:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF0B460A5BD5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=i+kXuQkI
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso533195a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186733; x=1795791533; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KxUI+6qDcU/AIs3Dad66GtLz3B3FQt8+aPt35cEovds=;
        b=i+kXuQkIkmc56lUIKyk2laxSD5gua7u3A69PGl8QAPGRz1fk+04B3Vb2GjygFot/MY
         XOTod9/JffQqO4T3b0ZtY6g35M66OLOZKzYbvsMDTS+R+dmNQ40BmvP6vwXcfUzqjPJA
         5OOLzHwflZN4iojhZcCYgwAKbpqic3DbJpRojugBpJBkaRg5ytUt4jw3pOISG7T5wPvs
         5vQn9OFDRBjhcpaRfXrUW5RWpYfex8xBgCjWM6wcnEclzfpZAGndY6DcyT6abRsXpGvZ
         XkPMCoAJodWq50WN884qHKKNXMJlvwfqtr7ko69ipZtFdcbDYxAdEURQijQkT6R36Mc7
         f2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186733; x=1795791533;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KxUI+6qDcU/AIs3Dad66GtLz3B3FQt8+aPt35cEovds=;
        b=2VydcVxmtrXT5jp1Jjtcbv8TTrR4bwhcXhRCQcW/UHt1kW8H5UHYtqSuy3lOLB+ACA
         FM+pfdG5OfU9gozzPmIkcLSGCDoRV3WwUJ5o682OKT+wfhRWrIuolm+pa+Br2VCRuneR
         LqRSkoJLLhxlV6ySFaLrWv6aCh8N0fYnf7vbhbrufzotvZ8ZZe/Glc/sVs+H35YLs1yH
         OKmLAftAv6SJ2bD0UClD/jQwizCvV+Z6/9m87lu56cXoF/XkB0VQMHRHI0TJ0T0HFD0o
         ug1ZIxPwOdVgymXqJb8g10bc9Yg4AbPGMjfCo6mXZL8vRWAXfBeYFxsw8+JVB/hBecaO
         2ayQ==
X-Forwarded-Encrypted: i=1; AL+hErH2CtCsQcfMBYM4+8c5GoRivgw9xKwg4bvcLUKKyDCftjyl39oPt2UXitdXm++JPKX+vtKBgdZY0LJ1@vger.kernel.org
X-Gm-Message-State: APuU4Z/UMTVxdbn6wDwJfuoPTkByC5Bb3PqVtUmnZ8wil+WPd0G1+ZaQ
	feZCXbngWKWFDxOlnHriijFi6RDil2qF0V919WRDUaWmTSr97TeLmJyyfWoF3dzh+r8=
X-Gm-Gg: AZFdTZc30qKX/niT3u5uD0l20wFbMOWMQMbjeme2f+Qnu3OhEvtjdixHqMDnPDhcMBD
	CpFjq0yr1H+y48h5NLovvnty8UQqKTyo6TTaKliTG0GAagdVtoW8YgMmNrLKLmgxMIN5WR3rGIx
	/zAkfEpCTo9TziIQrWryjnSkS0pHZrBSmMT03bBtQhW+RqjelhruGgR8e1dW8ejbrftViSmY5lv
	Fqkhem1abm8m2VEBNjAvaDjbxp6OAiZjLjLhGv6jh9l0HyE+Fw8MG4tXwLnD3yCx6yccaYClaN7
	KuIVzn8DGNWIRbdII6UZbt2O7itnXvbZk6KbfuFrkr63OJ6OolrSAWpNDI3s7lF1ugw48PyG507
	v1N9o3F/LHlnFPXCggc3+Ol+wUrMIQa8HGsLDuMDxf5u/gbGVpA4zpuM3nWhIdmHgpQ79E2BeUt
	zLLLpVfxNzdhss+7lEzKMfeetIrM2984dakkxjQ0VPSA2j0cEg/RU7tPwySycLrDtWQEfiyuIdj
	oYwnHyfp5s+y08ZQVR3f1gfMsGfiVRY50fpjLTS45p9Kp/lgDgmpCn1DzR3OB2hl0hVW2KkAuqL
	obQL0o9JCxzXCVCUueBKGazBFn/fUFMkCv+XvEkd1iVl8TOc/5Jxp4Q9d/oAvI0WvBNxCgXh5io
	IuEqYQbm3q3jZwbGD9ownUpvjhwEZw451sfk/6tUCDexIHj8KBKE4tcxfYm8=
X-Received: by 2002:a17:90b:53cf:b0:3b1:2810:dfdb with SMTP id 98e67ed59e1d1-3b41c964af6mr3085892a91.48.1795186733253;
        Fri, 20 Nov 2026 06:58:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm4724705a91.17.2026.11.20.06.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 23:58:47 +0900
Message-ID: <20261120145847.3127774-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 07, 2026 at 12:25:01PM +0900, Yehyeong Lee wrote:
> A target can finish a read without sending the data.  iscsi_tcp_data_in()
> bounds each Data-In PDU against the command buffer but never adds them up,
> so a completion that declares no underflow is believed and the command
> ends with DID_OK.  The pages keep whatever they held.

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
