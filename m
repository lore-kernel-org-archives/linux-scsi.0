Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793024676;
	b=UP4c/0JfUChZQszeoxmWlHE1djU+UOriOyx6vR4DAHytDbQxq0BKcwOhT7bIB/YomtHs
	 Zg+HmIII9f9DcnHR5Zdadp+fauQgpJzu2UmRr/emHziwiuQld16rxGvnUhEiOasm1vEBO
	 5yc72qUWnA+uPj/xiZ70dEBQNhsqZcGI5I2KlB0fOEl66FQFnBNTmP2+djs9XJnXSrxvX
	 lJcVmrewTE5keAfInKeQP834m32Qae1FDlnduSk6DVv6DyoCU+gbDjdtyfYMNFeE5Rj/i
	 k5+Omp78X1kRCUNH5HKG6cty43OcCJp8sywyGW4Pb6FqGiddUrnDmrw9a52320LdbCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793024676;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:MIME-Version:X-Received:
	 In-Reply-To:References:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type;
	bh=XGMGQV/R32o4fBLzlpC7+DMYEQzLmxFjxpt9zeX/VRs=;
	b=XsVOh3Ng+H8VYBKq2TE987Ls/wn79+9ZVpzuwCwtPYFBto3F5yiJ4m5sBsIBZlliAIg1
	 ZPPSG8gIrE0x53vZXJcERelfeQcqIPnQu9SXiP6lY5/jqqj8WrhGs9qD9cFEC3PZLjaG3
	 2BXDzTq7Y6gcyZakvdyrQb5QRK+8BMqJHbHNIJReM4hZprDhdboVD95Vff+DyUB89sF3N
	 i7eM8wvMqLLNC1SEIDT5j5qNKy+8cv6is9ZoYidZA037WurxHXoBgY9E8XbRnRB35LWxl
	 QuYwDm4J65npm3gd50vP15YgIK5MBWb60wffn21/aspG0I8z064GX5vRJjfmBp1ATiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G6SKTq7k;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010C606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 14:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7010C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G6SKTq7k
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a06da65d92so1797202b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793024676; x=1793629476; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XGMGQV/R32o4fBLzlpC7+DMYEQzLmxFjxpt9zeX/VRs=;
        b=G6SKTq7kbP+DcSK9Tdvnm69bmcExOkVrvq02hz3K/YXRMLS8qrTmo1oB6PWT4gNuBi
         ai5z8iRcUsXtATGLWvxO9obXbv843hjoW8P53cQYHQNw7aaTCvcCVyHpNCReRkXwvOOG
         LFRLh5XLdKkoR/lzjtpTsk2cVYuOmjjdJz8HNPZ/w7Y0cmCVE77Lx/XDpfMcZwN6FYSK
         vO/9WcnDcVxtgP2yX7hrEk6x4NCjMw2NR5ZlqrUrSg/TNTd5r0HAqaqbOTYreKGQjS0O
         GYd/X5OJrTRMM08Wu2r31n6hCh+NOxJ1E2/M3Q4FnkgbUaVuuy3OBuql7B/bN5eGW13o
         vnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793024676; x=1793629476;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XGMGQV/R32o4fBLzlpC7+DMYEQzLmxFjxpt9zeX/VRs=;
        b=idxbSmwcEm6FuN+7ligb9O+gNMlKVmhGeLX/orQwQHb1hOUni3pgy/Jje3iMLhFEdm
         GPLJo3hFgW3+3Fy2hlQLjn/tQMbk+c6w4x32jRHnzRcFQS+zvvSEZW7gADwogCs/ngJ+
         9YRj2O4HjmESkX1LttHZuVTmMThm8QRMXYr54gs7lB7EJ6q0ghl1Ekn0diCEzF1o/tBw
         +0PIRRLHkHmMWmSoyARptu7YFIlCXO8KkfgmPItPy++laUWlBlNIcZsYHkJFbKTMC+hG
         /CVExm52i5PpwHsznCtlAW63ckS/oVUyXDkjRMTfPcXIjQxz2HV6oNcfpSfSU3tRsXle
         VgBg==
X-Forwarded-Encrypted: i=1; AKwUvBwd57LIvIpvC7cSlWhPrYzTu1F8gwfVgAzqYsui/8ixp21nyUULi3gvEb6ULP/hXKTifBvQBxZ8Gq97@vger.kernel.org
X-Gm-Message-State: AFq9FYJXcL0G6PQTL/U+XO6+MRUn88XonSJ+gYSv7Rf+ZWvIsBYtoaXo
	hWXmvxDptkbpKQy1x05qhQ2vNhF8DQ0C+i81a6Zg3PNWvYCSLIYMogPoTKSAwqdg3f+2XzCGpM4
	Ym2gApuyuq43Ojk3+5nfgcA==
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: from pfbea28.prod.google.com ([2002:a05:6a00:4c1c:b0:8a0:9000:c7a4])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:88c4:0:b0:882:6836:25f0 with SMTP id d2e1a72fcca58-8a3692619f9mr5548863b3a.52.1793024675396;
 Mon, 26 Oct 2026 07:24:35 -0700 (PDT)
In-Reply-To: <202610261647385343iIt_Rpe2JeqxY7SCEeUl@zte.com.cn>
References: <202610261647385343iIt_Rpe2JeqxY7SCEeUl@zte.com.cn>
Message-ID: <18e21a713eb04af4.3137322e31362e3131332e313435.1a6419.0000sendgmr@google.com>
Date: Mon, 26 Oct 2026 14:24:35 +0000
Subject: Re: [PATCH] scsi: ufs: core: fix NULL deref in remaining
 scsi_cmd_priv() callers
From: Stanley Jhu <stanleyjhu@google.com>
To: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, alim.akhtar@samsung.com, 
	bvanassche@acm.org, peter.wang@mediatek.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Mon, Oct 26, 2026 at 04:47:38PM +0800, shao.mingyin@zte.com.cn wrote:
> - ufshcd_compl_one_cqe(): scsi_cmd_priv(cmd) runs before the !cmd check.
> - ufshcd_mcq_sq_cleanup(): scsi_cmd_priv(cmd) and scsi_cmd_to_rq(cmd)
>    run before the !cmd check.
> - ufshcd_issue_devman_upiu_cmd(): scsi_cmd_priv(cmd) runs before the
>    WARN_ON_ONCE(!cmd) check.

ufshcd_exec_dev_cmd() has the same pattern: scsi_cmd_priv(cmd) runs
before WARN_ON_ONCE(!cmd). Could you cover it in this patch too?
