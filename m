Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186846;
	b=Db8UdW3EfceoKKH8eKEOl10luopN5vVHgKBBmp4YbAGNNGlRsEugfVkdguO/ZtNuoqb/
	 lC2ZtkEqV5AJTKBp89gU2pboHUFlej5iIcHSZNYpwEe8PabaHXFGpgaqkiPZZBp0HBg02
	 5OM6zwYNhJNva79edXUtCFsjhpzInbQv1nS8etlPEhd5pSZ2dcMfdWDTOa+3BipOihs6R
	 8EmxJtRm0HyQbvmjls86dgyPCwZmBPOUyslMSfdwVoZalbrIIRVfkWJMNFU/OKnHjgpL3
	 K5YY5Xofv4/ZTgTpEHpQvlr3FQdYwOHat9vrFuIj438hMRzBs0bk8xxbcP1hqP+77zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186846;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Fa3jcQyOThRROqmsTn8P0YPQgbosLQuovg70CeMmiGU=;
	b=YuAJBfC+PGSqMt7pukhGnpPMEyuciOb3JsZpUHskbqjQg1prBJ+IsqxDulrGbUR6JgGL
	 NeSn+BbxziFmo2pHZDVjf5+SpDNBl++keowUfJM/LsK5nDl8fZAgVCdNwzEr0bqE7FWpX
	 Q4iLLnwjlwEYTkCCztWDBkY8r7Z6SoQMNR7kv13XvTrcBnXktC2if8rOPlv5lN0T2OA4t
	 NaX4McHH+BV2ZQ8p9D0dCp7l3SKmXADpTF2eTrOA3ZdbehxBMSRMrodhOJXMaSAhLi7KO
	 d9YnftILjw6GbQwAzHqM6Hxb4J6ShJVm0B4k0o9SE0ceFeYCkWncRzrAsr4RVX58njg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SlXPIqsG;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AC76074D31
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69AC76074D31
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=SlXPIqsG
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a070781f63so535614b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186846; x=1795791646; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fa3jcQyOThRROqmsTn8P0YPQgbosLQuovg70CeMmiGU=;
        b=SlXPIqsG2md1UteACDeJc5cyUDKIPa03VJqDOnm+BPxH1ub70V0LswUa7Otskrkn9p
         SmJMoi0AXDXaSfMZshaHCh3jKN8e9bAjboEnXxx/it6b8DPSRo3lnxKl6hnNlHuYEuHt
         roKqklRcild9RokAy4HDYXkeB/recYz181H5/e7a+zldqVJpU3YMeLnzLkp9LMq/qqcn
         71zztUcU4n+5ylfztm+R1tuKIuS+p1V87w+ruJUEEGI3rT+JMTptLTVRR/cw8sWMCTzW
         3TqCi9hxZrRpKOaNqahBL5STJus6k8tvXHfbNqY5Ol1VGAiH8/bGFTLrIKk56SQu9Cwt
         fo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186846; x=1795791646;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fa3jcQyOThRROqmsTn8P0YPQgbosLQuovg70CeMmiGU=;
        b=M6P9mcNDhEV9Avl+kE9wioSVARMKMT1xyFCG8FhJCLAR94ALYp1x1wCegRdianuyK6
         FnPDAaE+5IRtZbNWB1o6eaz0R5kkVJLzm4qHN4dj/249H67M9e0ARd06Em60yKBXmVuO
         k+9wACuVdnx/5q8OsTZ3RtQca9J5ag7rGzpTooKg6N44rhJOuJfFsnPe5oyfXQ1a1x9h
         bUHFRSJHK9mxrJmptk1ul72kJvKnTpPIqehIS3hqkNwHAFAcN0UDRxyHFtYidMvIk/u4
         Ktua2/vAyeIAXwCipdlgIQ1Rv6BWHdpNLDrh97k6426O4Lwi/xf2utpR8p3lgljotVhn
         AV6g==
X-Forwarded-Encrypted: i=1; AL+hErHpgLRUZzbVn9BIll9MVD/zd7fav32QG0cGMzE4/ZwUsiakuUuGA8mitfKDobF2kGN6DKeCuFvpSlQE@vger.kernel.org
X-Gm-Message-State: APuU4Z+pTZCVb0GhPnsYPQqlBVgvymFyputHG84NkphQ5fR/wFYSqSsi
	YpvP56+oS7LZYEz0rF0xkY3qpFp4sZqx5L178aMdY0tAJTjoZHG94Q8kU6FSvotrCIU=
X-Gm-Gg: AZFdTZcoigNVhyt6qHUgbqxdhD8vI8bKjTrJq5uUQtlc2bZVAvohhxcC5UvhLT0xESC
	SGcfqjNRz5LVKmS5W6EMflZXR3uiod/Khx/jF+Nfofv6edZfWT9UWhz1hC90NqMmDwsfv6tfVQ7
	vHg4u8lZy2trNZdbrddnL75eFmjarBLuMNbqpUjKKdF1zqG83hRgO3LEqSlzqMTX6y9Ip/8k/VY
	7soC2dFjlERkEgfvNVrDZipqSAekre8zsZQFheswAo8Zy6pMKJ3u2wsmo6EuSgbXxWaV9Nnp5/O
	FeyJ6Pfs8CR1g5xqlrPEY0SWvGhsW7l6SHHPZFAoKHctRfpJxuH/rAYo8ebtHSya85oWzi12aS+
	jUrCkIOhIF2jG/OAtNcuwFW9EcdTwtlIgXyAMUkWIBWPU0zR+x3eiB65iOp5bjqGZWxgIvFRW+/
	+wsVkKYb/WojDtbn/oi/5jUeX9vPkH1OnwOAdYbO6ohwGpLIes1Q0lvxfpVLm9KlEwSmD0AcUXf
	3PK5UCjFUAxjRKQiShlFsmCNP+gVAWQwbeBvrA6ESbdzgU7GYpXNdCgABevOyPdAJ16OlFJeaAz
	zLOm0VwIsHNCG/asqYLEK2d+pA7/a5auLmYDH6BN40df2q/j6/KV3RIrX1RbxnuNPSu+1suVTxP
	kMJrwDq7Tj/OlfTzqzvFoH7Y186zaYlBqnXh8
X-Received: by 2002:a05:6a00:170d:b0:885:e2eb:23b6 with SMTP id d2e1a72fcca58-8c87b9cfab5mr3322192b3a.11.1795186845677;
        Fri, 20 Nov 2026 07:00:45 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c873c1cfa0sm1603535b3a.48.2026.11.20.07.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:44 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: aic94xx: validate the sequencer-supplied EDB index
Date: Sat, 21 Nov 2026 00:00:41 +0900
Message-ID: <20261120150041.3128228-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 15, 2026 at 04:26:09PM +0900, Yehyeong Lee wrote:
> aic94xx derives an index into seq->edb_arr[] from a byte the sequencer
> wrote, in three places, and subtracts one from it:

This is superseded by v3:
  https://lore.kernel.org/all/20261015091747.4184349-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
