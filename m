Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175050;
	b=THaLQRPKkcucTgKCCV7TTxASr3NwgSOrBldDDBW0Locr7OQH/NvpBUdVS8te9zpIeALC
	 2gEoYkBrrgfBJcDw1s1NYJ5rBBPPKQpXwtLA31PCqRqyyRTt3tL2iyftBKvy8KPOsuovK
	 9s68b/q0MyA4UAGQd1VZ0Pwpi2TwhQe5Ufkvgrj5fbzod9y78+vT0/NxMF7ppo4LBqwlF
	 UuE2rqiSzai3suIh2xr5jUl75lnlf/Qyh44XcYbaOBBWtCPdecvEU5pZEXYh9RxURJnoq
	 bwKf5aB8sJKGwqpmtzc7131gSwpSWNZ+RlMX7r4F72rGnVzqnv8bB28e5cILkkagWsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=jZuVPyiqvIydeOsCj/w/P5Cxhgw/cB1t3PIa1aHewtgGK094je0JkILsX5KESZ3rulxF
	 ASSeEShJeujfC3rZY9PGFeSaU6T05HjAYaqW8J5umSkXZQ2ptxyh2kuLtOwwVr6UzO3fY
	 LZFLj4IkTxxKc+miHC/W1R/nEq+Ypbz835AtUxyZE5K6FEsTStfmPtc45WySUmfYC5RPa
	 akLmjRE5BLW8KTLYNGpyD0BVaQgBk18kP5pnw5ipK5lml5YcmO26K/QmW4vSITOT8QDaP
	 3z0k/bImSUsrloWJaSP38QIbvPmce/bJKTszK7RoozXTCe8Omh2CYO58Pjvlw64EkJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=apf1ii2+;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57E860A3820
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D57E860A3820
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=apf1ii2+
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2f02ee04378so6113135ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175049; x=1795779849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=apf1ii2+9gVuNmGIDC/YJL67ctf5NNMuqzUkk3OiiqwBzzmT8b36UiqDl7V+m943vF
         kEKQuDV2wjdt1fSaSuSoFZXgLIVvDat3s0/j0tl5kMP5jqd1x1iiEJJ416InTnaACQo4
         OcsDMp8Ga/HRmiWdIUIU/og2MGe70RbLttrruJi2kM23eRUTXUnElnuNt3BYXyrHbMVL
         Cjfw8cvy3YKeHoxLjYiP6DQwmvWlzBTWrnHgsJ6OJ+iohdinNIvbdMHEoHrioQWpjVWi
         lrXeqy20fMVQ4MlykdB+BEqkBbRxC8+5l4CBPQ3zoTtyFVy3Vts+zHv5QfZdjF+wCsgH
         6xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175049; x=1795779849;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=deYQcmiux7uHwrwb+tY8qWDDu8tH2PyCZlO9TusT0zRlcG+f+Yf0WYsqznUVP/fzCG
         6n83i53pfjqHilIkrUJBXSfLmkOhOB0YfPYw2k2nGZeu8VcovxEYpX7brThZ66PypNfU
         KkNULEk04AxluuDX1X2GmNRkkSlLtdNXGCbqaVi4OK+tTwET0ix443VNhY1dl28m1Rnv
         zl8wIbEZSgPvwn6Miek/WCeXtgFaVul1AbrVGcPw4hDgSz644dXP35Mm28suQiynrD6C
         K6TQ/HsGioUYQ3OgfuXZa9CKMJm4lwUBrrulfz3g8FzVVcFS4O3sIROBHFoLCfoBjCHr
         PyVA==
X-Forwarded-Encrypted: i=1; AL+hErH2Ob5qUgw3C0VaUbxkAbIbZSDZAMalFFicdPIhiH9UlfCS7ApclHt7cZUIOpZXDR/VzSCVsq2DEbVP@vger.kernel.org
X-Gm-Message-State: APuU4Z/Y/1ICYDiC6uhLsijc14zdw5kQ30weCbN6rWH5gWFfD3O4KhZ8
	vVk6FtTDMKkBpLWQa6sqkUg8mrfEcYrvIoDBhymxTzUjwAnt4qvkZIus8aVsajCO/Yk=
X-Gm-Gg: AZFdTZdOAf3MbqxGyt3y8J3QUIq0lKQ0bZzV9K23SvMn6KjRVwAGR8hMnAxSgFwzoIG
	WVJUmS2U6a+dI1AfoOlEdx1UYeU6Wy7Z9HUmjEUpjJUi7EiF3nHU4aMRxl/Vjx1hxJkf13VLbte
	DtX04Vbd+bcrbY2QHrDtmYpXnNyDveMWfy4xT19k2bvuDFGLKzC612ZTm3/n7u9Un/aWI6gpsYB
	9Q1e5wsTAX9shjpxvNY47svsg4A1peebUTxOYxjnHgflbVUyE64+2q9nNLTI2G9t6TdN9vrZ2Io
	WR9EznNM8RTArtHSnjfP5qHtHyHFd8X4zJ4FYL5TOSTDmRlAvHMTh4q7EqdNC2wcZFSCp4fAwff
	fh/FhW4TOZxe1JCd+GGJIXBpyVXDD+wyNb7pwMX3yIH9hc008pKJ9N3h23Yl/omaoQyT8Rj6sLr
	PJxAW18UDtQigrJ8P+QLG0kGd+6sJgvoNVaLyp8PuudpdBFSTsuR/h6ay+dyZR/ldDqMpCN7kJo
	EUUnQz0HHnmz1agIsx5pvRhMuiBqSqNJ4CIx/VqKnhb8YpBF2Z3DgAO5NEghKx7mg/XvjfaC73h
	udBHmrEyZuNQhxOnKGVU1ZReWlA0deXM37Jj5B354RJeDusLDwqqJDrZNkK3u6nW1IwK265hCBk
	GUSQfFp/yG3G1hjqJJ9kPqV08QX1YcJSMCLBo
X-Received: by 2002:a17:902:ea01:b0:2ed:238b:7db8 with SMTP id d9443c01a7336-2f03f26ee21mr29732325ad.61.1795175049207;
        Fri, 20 Nov 2026 03:44:09 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84425sm13850705ad.6.2026.11.20.03.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] scsi: mvumi: bound the values the firmware supplies
Date: Fri, 20 Nov 2026 20:44:04 +0900
Message-ID: <20261120114404.3072531-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
