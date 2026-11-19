Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094307;
	b=ntKVZcUxJoubyLig3pA0ndWA3IEvk9EYZtogV1ZrmHKFpO3ImnBVSTjUDbAn46J7Za8n
	 xThRl+aPHzDv/EfSsteogu5E2iFbmGliwpoUk11lSLhYUeEcDLp3Q8r/+1yTdODvwUXkh
	 U8GWkJDOKqTh23LYsAw+zTJriNkk/m3YMxVnxxKManMsL9vTap2rVezyaYVh3RcsrixLE
	 C2SDItWkjEGFffeYyCi5D302yXn8XbwIvLrLkwcKq8ys3bZ7tTwBIigzEcSi3KUnALIaW
	 OnKA0GMYjp/nN/81uUR7Gp4qpSd9c96sJi68S3wryVRJqzqGcHT3zVZ2qbPyuzFsPBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
	b=bsB0ZW7LcrjYJFlYou2ZGw5pLFen64+6dbk3mmHl22jbyGFp/Tusoqdi+K6vbIso5WUH
	 yohXFobPkwA3GjHu5X6QURM49BusO//aGcyNib+7C8Y2Uyk+Gapb10vkUkcwbvS81ChP2
	 dvubeWy2Lpx6438M/oTgR15KT7f8gOAGo85Tio41iYnZU8VrY9juIT15q1sqCnnh0bNFw
	 3S2PEZmYSjc5Lkay+aFWPnngyfODNjJksWj2e/BL1dd3Dn41BJCUjvn8CNU+fiyfHur5g
	 zjWkI9bmG4/mbt/PLRcs/v9fCOhl6FtuVm6M1HqRg0/puCM480Xzi/hBEIU6gsDo6Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9F606A330
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 13:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6D9F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso773564a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 05:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094306; x=1795699106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=PnsugRTi43kd8Jc6wW0hk/YmUu0oNjvvRG1DQNje/m8SbD3TlSSeMEupfF4A15j0K0
         HHQbAEpzZbImTOgkUBPzUgfM2+34y+Z1Z3LIGfstav+IDG1RD4I2Cz0fIFwUVCFgap/W
         ko9db2jEwjEMacCCr6UIQxyv0rQFSJbLtRxjZVppSI41nq2x19GgjfGV/qPASE07OR6U
         1OppQBWCjSjSHcxZYnVd9Iq9hI1paPuJVUlegnwTpsZdlrGCng2ATgrKzd6hLmo89yy0
         gqeWEAFW62yKxK36qNil/zzi7Qh4eIVuAxFDAwaoe6Cy6S73PAL3j7f3kmooKXmhtUGi
         i2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094306; x=1795699106;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=JU+9hsgxI2rqWJNNMkuJwzDl355Skil8DeZ6JG+RSqWXFhq9BDnv+xL9ab2AKp6Zpk
         iwy52LBJ1YJ6G1gj14h6KWAsCdV5elNIRqmVk7gK543cAxjRCubZBw9FINf9gOTp8Ipq
         M+x7pzem+uK+eAjjyE10wZlXNMvA9wlOz5yKhsCmsCVX/J9OAWuep11/7aglqszSFXjs
         CRXOuQalvr63LwzV23mrbsuV0alwzHl1eQ8Y2sbhdurKiPO2NKKQLbOMwSnQJ4xF2PqJ
         Q3M82WXe8gFcZ8DBljm+EnBjDB+kSykE8cBwEMMRl716QePSOmcoVUj1xwv5ws8BSZmL
         lZMw==
X-Forwarded-Encrypted: i=1; AL+hErETb/sav16IFngQ0Uma9WS/AtsWoFNPNbPy5jVJV2392PfOMvrJSUZiSCEEbXXDDR02W7kNoG4mkDU7@vger.kernel.org
X-Gm-Message-State: APuU4Z/P7AhoGeTYaokGkM6ukjbOXmLvZC3U1XNLtA8NVPF85QT8CIQ8
	4doQkS0F2tcfp3/6Sv7Up0H61tvBWyw11S6HsMlRXBel0lZulB6zBicf6P0DjhRzsXNqKsaojl3
	ezKc/IE4=
X-Gm-Gg: AZFdTZeaqiwxQ17mgj8BNFEILO5hMkN6bHeOKGrsn9OBcHByy8rhLNYPUEDY2hsbBoY
	gxRTD66kye7kIQ0i6nZ//J2Q4N13SJBQqFwgqV2QLGP/+EYHPgOFLKU31bfexFrHcDvsxnQ80dp
	LFqj0+bQCZI74WtSrkMJO8WpmFZx/BAh8ncDuVCET/MMH0bQo3nCmC+426bNleBg+Z/dZEgX7rC
	qugQ5/rRza2mOCOOS+CtsXRDNBT+qVmGHvDv4uy5SRjjQxIGPJ+hNFG6ZUQ2744HiPSI7qKi2aG
	rrKIpJEfVRWx25m9w249+XNG/10xU0wjvStbVkukr17oNIEZFzbfBFPE9uA9ELkLHfRkRyiHziv
	x2qw4y6k8SGDQfJ8814S6leR2Xzsh4FvtgZSuela9nqYD8+Y/bHyT10+1pv3d8IxtVFgmO3Z/3Z
	IzyQcDCA3pGTV8/MDhvdKrz4gZBwZHpNbRfZsakOvFcWjqtSsHBQ3bFcuNa11vyx43dB8Xw+AJJ
	8YfCyXZancSvZxz6JNugxqw9ShQHYi3UpyJVtl7DxcIBM+FVRxnztgv/aYjwrz5PwvAxruzFmRw
	euJ0/bkQzx1auxIurWbpk4xzDVejSdn4o6Zh2Wsv9W72TL2nsoiJ/vm0t4MXDflTHBrOk5qGZ3r
	nY+TKIVH8U62dALhOKrSxG8yohxzSF3fkRewodQ==
X-Received: by 2002:a17:90b:2c90:b0:3b0:9bfa:72ac with SMTP id 98e67ed59e1d1-3b40a0e1cffmr734949a91.21.1795094306265;
        Thu, 19 Nov 2026 05:18:26 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40543eda7sm2794953a91.0.2026.11.19.05.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:18:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 22:18:15 +0900
Message-ID: <20261119131815.2722343-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v4:
  https://lore.kernel.org/all/20261119131700.2722108-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
