Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745466;
	b=0ju4bvetm5Vs/89molLQg3mu1CZL8TtonCjMlmfUviRjX85ehrueVRtKxBZnfJcI5VBp
	 s7V7Jv6oizRPdyk6dwtiU2lONQkfI2Bnft/vyYyvcPr39/3z2D8pBJvpNFGCnabgWM+FP
	 v2aGWm45UrbS842hSN9zZb0iW9OMtKTiJmxiJBkQ4uQfdgKNShVyUy2YLKsSLYmSlHfrY
	 VRu5UvXFgiZRa0sfnhjdENGxpwV3POB5LAYdfWqPi586yawRsGZ6fkn50db6WjarQRlbE
	 4s8omWy1k1Cy96x+c3/ZYXsfPSwQ7P7PbLin/o71hf83XjUCe7jJq+iU6rvWFR+RDVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745466;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=+glsQERFZEZXq81RagwSLF6fsoyPTibQ4SkFNgoTuqY=;
	b=4f9GmTkWGLUiVqDOVcpSm3nxk7M2Yo4NL1ymxwv4Q/EKt8sVqGb5tMbYQiLaofX0WXCs
	 aZhq8qsKe5M5oE2FS5Zql1cOSRnJ0h5bUYBOINC2joE431kPJ4Jw2pHMYrA2A9ivWXGKj
	 xbH5BJcwX8qI9I+9M7G0fK1pCJb+3ki+rClPBgFSR9CVuH3/yK3yJFmrT5rXXunocCqt9
	 ditS0vm1Vjb+JZkbH4dgZmWAe7X8SPsCK5ShnoyEUJhnL/oEzW6BX2tc5DHcX5J/aGJYT
	 WWuqDpCPNTPqkL7/joSjJFYgDs/IBY/dxmPn0620bmyKZ8ce6ajyTT7SS5h1YAvskTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=p82Yr65W;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B7606A31E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 818B7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=p82Yr65W
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9e53d011eso25343575ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 04:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745466; x=1795350266; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+glsQERFZEZXq81RagwSLF6fsoyPTibQ4SkFNgoTuqY=;
        b=p82Yr65WUgghLE3IX8cyCHO4Kpsp90pywE2m7kI9fyI8p/avnhWhnrKa7HCrerphbZ
         mQqlxJtzxf60Qv5UsnOG/ciycpQZy+5OHHAaEJb4wLocIvegXLaAtffVOLo1GDl8BkoR
         P0h7Je7Cnp17bm8A02TyEVE91IS1vbJ/NX5tK8C/mQMOZOs2l+5f6HNIVQ3TGCicHkGx
         AQZ59/CLA+DPkiFX50ulhDSeJYGTkLG+QgN5rsv1HnsgLxOvNxCM4w7/bzLTNg2kryxo
         jlvWRkVpRH0BNXj62BQeNKFS25XD75uQVMEz2xecWLgVLqInHPlLrxkK/zgJ7KNnhxGr
         p37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745466; x=1795350266;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+glsQERFZEZXq81RagwSLF6fsoyPTibQ4SkFNgoTuqY=;
        b=HnUI79JGNbPwvJgVHSoGBpa3I2nI90TzfLOMeHrI41qJOZIwVC1LEeTqTzEfwTjJhY
         tYBcbv9sS8c4t2JfiCkSbAKoG0RMmMPcw9X47yb3sFq9eYjBVt5/fo8R2OrTvlJ//8L7
         fjxEm58z63L9jAVpLdjRvVfab4QN3kV1uJL5xQMbm3ESUfRuViNgiE2qL9cod+m29+NT
         2pqcYSY11fXZzUwcgS2YWzBX+ifpJ0atw9PcdVikazOARNin8r42xNhF7swmyzrR1of5
         z57yGQHgpF2rZ2ckewcIli4ethYFmp3ZKwUSXAdNZ6DdQwnG1cxqoBrf8T60hismoMur
         bV/g==
X-Gm-Message-State: APuU4Z+SYcf5nMSwl4OOX38T4il+N8X8Y622n3Cq51KLCFiSMoKzJLRq
	Nf0eAOw+ZdaR5tIfs8ScOktNwUU6kt8ff9TfkCqUqlEqoBnT3rXRpkj0H2FYThNFpxo=
X-Gm-Gg: AYBFou2pEz5GOo9Dd/57chffTf32e5mnCfXiMjNQrwVWNsWc0hWql3XO/UMAd903M36
	fFcp190W7xA+O9+472xjlva7rTCE56myvVFMVDbez9//slCYXRMuGJoCSgt/izRcSdBBaZLnkfc
	qOB3u+G7kQwmr0kNmSgYsOyqKO99uIqdAZEoveEKevu42dWPz9t0vW9hWL9G1obMUbXzUhgldmq
	LKWBH1yIUrq1MCz+19LjqMirFsbi9pevC+FucS1thQqkrZb+fp1VIqRQqgcOqZ8RBHgqT/zCl1Y
	uOhNWH5ErmKyMQd1SlIG50eg/QHNrg6Jxbx4Q3F/lm1rfNq/DDWYK621DFpIjgAr/nAT2VnxQwp
	CkyHn+m1OscbBgjTcDPBVfUaaFGrtEdoz50EhzRzuZD2DEzGqOYBeZ/W9PB+A2d2bSRpMZIWAWt
	Zwri2nYOBxxeete7E80IF9hknhVK1C/qNDC2h8VvZQ8NDk3PSIKfja6eNzfjXdtXT8mgyBO//Sp
	IPOYUW28+94mB9wyYfdWfom6U9THLcVfFmiOs6c2oS4V3+YAUzN+qhqfAg/Pv4wLuKLNwz0U39I
	buBVsm9Hm5xWhrEqSltLEZbOg8VNBbqZWdIibR26kViBrCUABZQqCgH03k6Ve9bkdbzYWlAg4yY
	Fy+LvYIne8vB4c13x7Eq37uJSInBZql2pZ3EeLg==
X-Received: by 2002:a17:902:cccf:b0:2e4:b37a:d583 with SMTP id d9443c01a7336-2ee0dcdca58mr70807355ad.61.1794745465955;
        Sun, 15 Nov 2026 04:24:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee10efc2easm27668285ad.1.2026.11.15.04.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:24:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: libiscsi: tighten management task completion
Date: Sun, 15 Nov 2026 21:24:15 +0900
Message-ID: <20261115122415.1446881-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
References: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3.  1/2 and 2/2 are unchanged there; v3 adds a
third patch that makes the transmit path hold a reference before it
publishes the state 1/2 tests, which is what the three issues raised
against 1/2 come down to.

https://lore.kernel.org/all/20261115122122.1446791-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
