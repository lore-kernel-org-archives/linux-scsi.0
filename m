Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186746;
	b=VpeZGbk+VM63IRzC81PcC43g9hdMgwwfqEAkFkz/atQEeDd2ymlskj0E2+P0WrMK4EqP
	 dfNitZUYatO5kjJ/Ss+ySEvW1Xaj+SGNaMBRBiOQYRWcSVm84jhY2njeqXLNcgoIT5ZZ3
	 rDjiiMR9dMxcUZNQW/HX98vP/Nxh4oWMWMVG/F8eMW8BSuHL98hA1h/Rw773Pls6M+HRF
	 EvvosHbktA1n9Frk/dTHJvCOLZOAyHPitm/XxojAZkm7j14MlcXT4n2mXoVzD8Jul1sbx
	 8RBuNozMexkYavbDNnctIKwdVFucDvLKjgjrIHU0MEOvQ5AD+yFYejXWdg1H2s1L6Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186746;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=P3+7kBc081Vb4cFjGkwTtYJDJuy5LT0yIQH3AyIZp88=;
	b=wa21E9uaGgt840bzaBhlOu55/69BTdF2KKNQljTXacOf1pgpGUXq/B27BNTSFKfXN1ZY
	 wfS7IH8L2/vvtUH+6/yoYquVzJCC+GMw3P2kbNvWo5qLM7L6lsnbjPgpD6OkZFxj/9Eni
	 x9zBSoFmeLHdTLz2ZSKK6UhkYEyDLP59M55yMovuETj1Z5TYgyt5uVc3P6cnASXzj4/nH
	 dSY6butOASU1ByuJgg8O3bPhhqeBKXDQdiunuNeWs71NRhKn9C/n5jB4gX4GKMu1riTX7
	 h0Uk1W9DfI3I90WReBcTON9s/T3txEamK5MGjz271KEBdCTd45k10AHSUwGpoxdt6Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=eJJD4wsO;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41AA606A333
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A41AA606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=eJJD4wsO
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so553673b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186745; x=1795791545; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P3+7kBc081Vb4cFjGkwTtYJDJuy5LT0yIQH3AyIZp88=;
        b=eJJD4wsO0Ec4QZ/aDiwrjB0qES+bQiQ/peNT7hxVoQQJkapQO7cfTmI3WdpLc/rPAW
         vxlKSgqa4rgzMh1fXi+s7bsxYgiWJDAIXIkyHZWw0u/IxQO8iiAHpHQCrfpDrpBb86DQ
         TDnzQrwsihZ2OIhSk7iQLnsc3wu66u6msI6yhjdpFMS6m3PfFftvccP/fAyp9NkMLNcX
         16LmFFTgURk383Vz3JsPgD1kxXTl47yp3kfZvFA8sE0XBq4xWQwgQ/ayWMafFuDYe4L+
         /6+SMHkHSuRD2E3NGGMf7GyvrWpTQpnpb5yyiUmO0S7O4uRyoC1ss78KTnA+2XkAliRu
         /jnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186745; x=1795791545;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P3+7kBc081Vb4cFjGkwTtYJDJuy5LT0yIQH3AyIZp88=;
        b=xlLAkpIpBohQxCapNqATww8bjDdX/fMIR6j/bRFGq+qT/bF5jrP0zu9ZDB7NCMsK81
         adl95KdmtM2ixtHs5hKfNhfQqmCR8TcUKsnmdm+j9kLEEmasV73o1JtQ2eAgivf/5FEO
         nPXBXMtKDnJY3FUEv2uA99y3P+0LEv87N/YFSlklPq/Mq3HAszEwDJFkv2ZJ8EZaP4Yx
         L2QkkAQZRUqYZPDICdcx1zkAZ4c3S6JmDTf00CwTQj+gB0j+VFWhHL456KrWRQeFkKSf
         WftKupfIxcC+f1hJ1Gx10vyRSYhCjI0wm7wx1uqnOeB/xYPmQiLalPb46MU5XfFJRZn9
         sVfw==
X-Forwarded-Encrypted: i=1; AL+hErEo6oeFUJK4jSaQSnGGZ14/iKuKwByPKYtIMDN2S5UzGJLYUiPNhv1GRxIJp7dXEi7PSDc5Ymrv2/Kn@vger.kernel.org
X-Gm-Message-State: APuU4Z+w68RFcSjeTAdg3k4BfvtVx3/JyKgOd7OCpvUVOJpy5Aopf6Cw
	u0POUWedk5I/0JHXQm8gjPle4cqAAwGYeDhgbD41QmeBMR4QiHC6LSkwL3yDcXecGA4=
X-Gm-Gg: AYBFou3C5sNDJawNjCwbxhtWB8s94K9rz9thAyEwFm7iMCZaO+2Azaz3FW5ll+OyrRf
	reCL2BGVu3qiGyIij+1CSo8fBRNW1dWK4zK5sS6GdCOiNEilIojZLtsEhx3cfdxawvWjDPYm90f
	KHxeHRDwrdaeGXFWiajbDuKRZJ4Hzefy7BSW95erzLpKUiDnTfLgPFyvB+WTxjwukbUcfkK/xlZ
	hZuM7nFtmeFbqPQW63it/zDmYfiUMCcAQO80kMZE4wxxh8gGNqp2qAcKteMQbXMv656xC7LrRPn
	2VurqpCrJp0dq4BLBtLHn/uNTWS4wPybcnlAmEgUnqtc+arNo2qV/sB/Ra+re+OisVg/sJyGzK5
	5u1FBtmReNYz4+k9tyOkSvrGpe647qaPIMoRY97HulvAZUn+CLrZDjpLXJE+RIMcFtl84TT1k5u
	N1A4ElD1t6eN+848VuvJWkyACiQBI0yqvJaCmGZKPLiY1584eG4etyZAzrt3N6UBkVvwep4PSd8
	t24BOpggVnZn6BspcytPCNOzEYR+8fQpXvRiYfWinVGzAGmy/X0u+6daE3zioUYSPAidGEDbcAX
	OVlsCD+7qGQR8Qd0Yjmc7qKdMJtDhYULDT/mUGXvvBOpE6hrZK0xeyaOrjZdEsE/yt5V252s9CH
	3+82OmdPfZQLlZYku3gkmpt9ML5Uv9baxMF/L2kKmc/KFVwOEoJj8CsDfNQ==
X-Received: by 2002:a05:6a00:1d8e:b0:8a0:7c97:52a1 with SMTP id d2e1a72fcca58-8c87d124d3cmr3133566b3a.48.1795186745028;
        Fri, 20 Nov 2026 06:59:05 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4af1fsm1647354b3a.28.2026.11.20.06.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:04 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 23:58:59 +0900
Message-ID: <20261120145859.3127816-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
References: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 07, 2026 at 04:02:06PM +0900, Yehyeong Lee wrote:
> A target can finish a read without sending the data.  iscsi_tcp_data_in()
> bounds each Data-In PDU against the command buffer but never adds them up,
> so a completion that declares no underflow is believed and the command
> ends with DID_OK.  The pages keep whatever they held.

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
