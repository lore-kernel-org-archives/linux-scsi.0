Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910649;
	b=PkDpHJw6mEIwBwOCBowoCFEhEPTf/tnEI0JAhvf9m7Y3Ng1sMWPg7l8AkNclobImru58
	 69QMTDGKfEMeTaEczLYYh5HFopCS31fAbuhSXsE2rb7XKn22FR9kqtkKd4W5I234j1m7N
	 F6feIgyRT5/p6EBKZzvf8pDLNpRv7pEtCS7geUoKSUY4dFT+alm3TOtoETIBXP+s0mJIQ
	 tn2aNF0WsH9BxBF6xBy6AWE8g8OOYLrEx8g/kj27rCKizvWJj1KC8im9md3/EMGyWfqTw
	 IUxJ/NSmBF1f9d/LnJcqHuk2tFroImk3dr2lTIw82ljTF3iZjBDZpuFA+NB1R/f9CzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Mi1vb9N8Y+TjLnAkkCLxRTFnlP/8A+F5gvm34F3Sg+w=;
	b=gLCigcDpBT7YHcPoM3FbPZvN03YEACoCSL146c6d041yB/vmV15M3TUlbEme7S0pqFJm
	 ri8TSKVn926nOUl8qbMBrwThCljuZhdKIYvrziFvxy3s7MUqShdoGXtYay960GsgyBwCV
	 sBic8fPr14TppbM2/zlJ5gA3wQYMN+d1pTgfEt925Yq/OS9ulQzrIj+Fc91qStFEMrSqB
	 SKnS32CQf1Pc0CFMa3W+k57cbSAPqCS0I1O6qIrbDH2U6F7+iH1bDIjLtMFfT0HwwFdAH
	 hWA25hW4ZZVxuuf20ESS4KlC2k5gYWBQusBwtpG+EOej53KsQY3t/c5vRS1ivH1igWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Blfe0VBV;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BAB606A32F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:17:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84BAB606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Blfe0VBV
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2efe0e3bdceso1840845ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 02:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794910649; x=1795515449; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mi1vb9N8Y+TjLnAkkCLxRTFnlP/8A+F5gvm34F3Sg+w=;
        b=Blfe0VBVk6XBuD1CjCd8cykxB7IYlSXGN/tmUAJYufKAqDnzUrNoywd1F+2riuNmZQ
         Os2377INfGlHk+allTN0lieFZZo6MMAFklF7TVMPjIITHv185YAskZqwwp5a9RXLZdfY
         s+GSZuJP7R5/FopLc8ZZECScPrXjRkjOuSWuJawtGdkDqyFPO09aSfSFC3H3Dppu0Xag
         oh+sLaxyHd5VTNokBniyAly41+RccoY/f9WiWrR23dpPNu6NypWf1kl60AOG10beQhUG
         EXfq8bcb0sm6FHCwIxyG+vt5JveZhk3P8VytrFZcXz9Jm8/AuwNTdK/K6mxuncN6Eb1j
         csaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794910649; x=1795515449;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mi1vb9N8Y+TjLnAkkCLxRTFnlP/8A+F5gvm34F3Sg+w=;
        b=miQbHEbLdgQf6LM0yEminu5ORM4ZwTRkbsbv7THr9fPkRzP7T6zL4/4QzE8ko34cy8
         Llvox7JEdHhOWnrplz0C7HSzoSk5/qhJ9RK5P6LrqEZhe1Q4sq/bGeMFg+4f/AnAYNqp
         D5X07hijRjFEwHO/LflyEC6/PdHfhlWSczsxPw5fCjYmHhE/3wyUdqWkeLz0YNoFukfu
         o3PWptMOReF5zQRn6tvLKJ2zTSgJpZvtmGUo59LE5tDd2F/QV2iTryYgH7MbUF5UfhGZ
         4rJBm8DD3LxESatgZ6rdnQ96xf86pVYPtabPv2CB6DMzjACCDdfzumNHUk+S0sWymGxr
         lYQQ==
X-Gm-Message-State: APuU4Z9XC9J4xqXgF4q9SqD8U8nbGumv5i9eBBi6bkACKCiR270RLIBD
	RI5UnYlE9Cf1eEzPmjp9ACyBAYi5WTSlPpb5Nx8jHe57N4qr949eCeABYveG4+6c7nY=
X-Gm-Gg: AZFdTZcvfK8ZvbxdSRzFA4w8MVf4KNvl17OHfYGedEz9SOqADY+IScs3nrE7AjCHMtV
	EKovpq5yl7+4WguAK2BBkJDB7Si2UEkTMEdc76XkzxXP/agaUTq2H4aR+gqtHKfVzHFx5dyjf/a
	Ke8uceu0cvm04WoyOtxE34mKzn//SYMpStlq1fjHRaN2iG+14kLwBmH4lgeyA9CFLkfm9jNdXbM
	ntSKjSnvwds9wSBptz86K2IJKfVNDVqCJRAG/KQxfR4+yN/aNU7et1VL8+OBk8TCx9HoYpv8S6p
	vgbEvFu8nPhwn5O2NheomMF3aUlJ1pjYgFRTXthacr6fD5L2cK/xPVfeywEC2qDhkdCFpW75mUS
	oICZ+3mxFVauOK6ex3S931vdIxJDtTRdDBXtcmASh9SrXPsS+Zd4J9grBW+S0pM6J5nvX5ApzCT
	XGr2wyAQgm7HONv+ZVB2r8mVKL43GQsVBXT2ze2oVW5EfSxyZoi04OGEaKeSTrNXOIP5pc/4Hf2
	UW55ijjD2b5ajzuwsyqjGClrXvBjxj2E1n0qEDiiI4Wu+mKX/aK8CxR/Jyn9BXOgzvnFxj8kwC4
	O9yF9N5GHCbRV82GTNd+4Fa8kq/hjWaXff2LrJMITyyUO+l+F/CT8GNEPdLWCkvXrUqF04SXcxA
	cppumJgsheU3WVZffSczpbjwU7TJxlWJamEKZNA==
X-Received: by 2002:a17:903:1b0b:b0:2e9:9f14:c44 with SMTP id d9443c01a7336-2ee0e0bc9b2mr139528585ad.49.1794910648848;
        Tue, 17 Nov 2026 02:17:28 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:cd44:de10:449c:756c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd76d8668sm12633385ad.6.2026.11.17.02.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:17:28 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] scsi: libiscsi: tighten task completion
Date: Tue, 17 Nov 2026 19:17:20 +0900
Message-ID: <20261117101720.1894905-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
References: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261117101500.1894608-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
