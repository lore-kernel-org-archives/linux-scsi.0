Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174979;
	b=C41UATMgX6vD2HYMWLtUkw+iiWO9KWnvwaoGbE8Fg2/gDujbQArfIrQAVbxCOfp/OyT8
	 9tTMl5w7E7VfsBEVr/Q32EOzxizwAPPTdYaFFIWLBljJiui2eF38oGKqqB2JKGA8H6hDR
	 GUNoqczxV5hwg5DyOQ76gaohaDwkDGDFImd1IWgOC9bZfVyfWtkWXfgxFC2knChA/MAwE
	 3Fr8wD26Yca16+AciQTTK8iBIHMzAt0GtsEm7+ydbLv9CKaLlzorJyq86L3Mv4TDmvfj+
	 JNfVd/s0d1ZmAouaxfURPyWDR1UfenOMazVbMc88xufN/mslifdHK8NVlbk97UR3YWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174979;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
	b=V7GLPmefcQZM5zGNNhvSUdCRIKOJN8/l6y0yIuXh9J+ZErkrIThH7DEklLQaCGYeCLno
	 sv5TmHT8pbDK6kwFDSwDd4UYAdsaRPVnjO1v2Pl6/I8b1uHwfR+nHB9iB9OJFcBy6ccSN
	 13FiZMAt/yrvyNWVNUMEOkO01+R5EYqAqn4iyTrkn+RQo0uL/Y6G5TRo70tnxNpU7G2im
	 jDUK0ITePt55K799NWqiLUWyPr1OajDbrsR7RQlapIKHywwyxP0wVb/8CV8HzO+2nEvN9
	 8Ps1zV3NxvpH2c/KiK9q1A3sjOBFC5SlR0dPgunaFM2JPj/RZQbrWCEufVac4mheJzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OuuIYDVK;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1792606A334
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1792606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OuuIYDVK
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8c5ebbc5150so652534b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174978; x=1795779778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
        b=OuuIYDVKYgTL8S1jZEfJBv8cEwn7EoDL77Y7V3LZ6qxdinqVqTaV+l2xeo/47tPyHa
         QIgtoGL8QF+MNLJAT/AyI2t4JsX1u18bSIajv/kw/wpL1uopw65XvB3GANIMGFJFlkKv
         PFk8r3+bBKNwClRGZl96QbHfcFNZg4NiUaqzYEhU/gx1gzEP+aIbWqwryU8nOiJ39V4W
         ++DBSND+qXvAlS4mYK6ycpQoc3tMQTf6oDIbI/XhYLHqqEzgbLr7mV6jXuMZ0okr4Geo
         sCWbF7uIFk+9CK8St/Th/ChxmZoggopAVRX4g36IpztnLB7T3w0rPCWnpYdtuR1OY/Op
         8yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174978; x=1795779778;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjnAbbZXJqzEeTrkOsVqC8UhuwiWl38xBjiqjnKRGyU=;
        b=rj4AstyiifZafSQxmLZoFBV3E0WAqDQgdvn8y4DpRg/afdhElrjCSXftl0x/5DyLLJ
         NOUUDBd4e4GyFoHx5wBm86b0IoRLPhdSv2+aA6jDG3GTX8UP86NNlG94yzE3/jwB3Iut
         YhDSgrJeNGrVBin9awhq1AaLHjyvqja6libGJUcR9dmYcUCIBXHGLmxx1Xrod0QLTJ3c
         lWDvdldR2ySy0GEVxybtInrPGpEgAk3lpbyWSRujGELBfuKV0u3zS87XoqF+PLS6lO5f
         SRTtb37ru+7DO1M7GBHMi7ulhi2Rw0XZnLXIoa0go694qihNIFGWb1LkVDLI754x55D5
         IW9Q==
X-Forwarded-Encrypted: i=1; AL+hErEYVEHu9V6UjGCVRZX2OdJZTiKfsnmsYLc5CBOLUWULv2xN15Cy+4QZGDco6ZQFba8Vu4f6JbBof7Eb@vger.kernel.org
X-Gm-Message-State: APuU4Z9pkEje7xfuDoXv464CMsAgNCxprxTXuGi+ShvlnTM0mKTbXFOQ
	StXiOLDoECg7PIhvv9CKMCJFGF+wH/ZymrQQBSmHSijsMippWG0u/b3bQrGgLRPcU7VDQjfP+fK
	AynwHiZQ=
X-Gm-Gg: AZFdTZd9yiqKZcyCRIqYhaII4u5w0h4gOJ7S5GcgP3vwnx2+6ICoNH5hrRpKkjfz85A
	WSgMqE7cdgCItD7+IO7ATQtijLEp5mcWC0QEU3tURzQ75TXStWBAxBR6EhfY6D5TssZZbqWG8Ei
	azX3M5wgxNYT1f8vum5D8p5O0wwKACB5T6BJEwIF+OvYfunBnwJnK/MFJP8xHvWJzzvrOHHrE5Q
	+50sPMEUwK10SyFe+3kDDTjtz3Zu7xIgSyjhfykWrABpMWawPJr6UKV3ifZN901annVoJWbg6mJ
	uOwOMmviZj3f/LAOS+yEsPOQqwm6WsyBwyEaUsYRxPjI+N2BAdHzI/eayrSjiaZ5Xsvv9s3kh8A
	mWNySI9iGBvG/X5YgXzYtpOs1SE8DuOFYcN6sYEiuKMGgY+clf+odBWsbVxkJeQ3ECZO1ST0WIi
	w254vas8IcajyUyb707cd87gbvnsqTK7d7DhX/+xMxL1S36aT0pkuT2jKSiQmxD+UETSyUYHZOF
	USs1brR6ddcfQs2RS09HiSM5q/6CQHcAox0v7WqPmtL3lJ2MEWLOpuX5X7ZTjS/xqDEGAvIXEfX
	H3nc5ioV/zwDDwMqkWL0vXhHoK5dJmHVhBC4xGNxv8nP24rFDFkEFdIskRIM10swnIo7XMKTsk3
	0mcs3RNG0qhft0Gbn1ndHA3eWcZvkEhEbL0Kd
X-Received: by 2002:a05:6a00:1ca7:b0:89e:99a6:4673 with SMTP id d2e1a72fcca58-8c87d51d50bmr2674815b3a.60.1795174978317;
        Fri, 20 Nov 2026 03:42:58 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077944bsm1406465b3a.2.2026.11.20.03.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:57 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: bound the ISP83xx reset template to its buffer
Date: Fri, 20 Nov 2026 20:42:52 +0900
Message-ID: <20261120114252.3072228-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
References: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3:
  https://lore.kernel.org/all/20261011144752.2063334-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
