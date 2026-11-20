Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186863;
	b=CeNVe83c9k5Gfr3hFOhIrOO5XBcL5JV7aCBmhpWHP7l3dvcqGibg9Y7RQVtTfR9/EX3a
	 sEWTLXtrG+08ym25QbJVJv9KL9Y7nQiMCDUwsX2vphrsQ+pAwSQh3chRPz/gVmp9bBk+6
	 623V4AuoyRrT6XnydGSMHiYISToW6q7hA4MLxaUYJk7o5ej+fEzbEn7pPDdtBVJDALFZd
	 lVqTBaEBN8+LT6bTh0j/P/c8mHAk0EAjPoG9/zjugCRVXLyMYQ6UNTWqrYUJtfMiN/h27
	 sllEgyuaytIrB02NagDXxVfJYvgR/4aB9EtWy7aJFN3N8DDUUMZq/HKmtWQT70EljYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186863;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Gzq6a6gkghfYBMHBo7rUmEzdIfmyBieLV65dMGxy5kY=;
	b=Y9BNeTzzjmG5iD9amOqeGxvwv06aiCiDZQvNVR4mRw+P3LqLkLApjGerdShH7G/f6RV8
	 5IgaiCwtg1R734eu9X1q0gUyFyXZJg5ZIO2ZcVQ0GCM1De2W7Wz99nLaZrWmXBhg6KJLs
	 x6jxDSrnAlRxNFEi2I1sQK7iLzEeY8lT6Es5mOEwtObRALAqC9mlCGhcjomCe1VifeFA9
	 2h3n10P09hWr3salCAuf04K0HbY3QHV0jnl2xp3wdRDZY4y2b2LAd81+shAhzvjvuRqum
	 RuHpi/gwJf3Ybsue23lYjdz1S0IBHpWRmmtQWo6e9Qd2dGSOaiPMQYvPC8mEwLu3hEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DwdRcjh0;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0131606BC81
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0131606BC81
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DwdRcjh0
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so469278a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186862; x=1795791662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gzq6a6gkghfYBMHBo7rUmEzdIfmyBieLV65dMGxy5kY=;
        b=DwdRcjh0rc0O73BpFcCwSUppO2EN35m+nDgRvOu3HbneOBWbsfJtbestzIIb/6jJmU
         rdFYQkgzEd83DBxoHFsoeQ0aY5hsd3hXeaBvE8UrlMGETg67ZZZ5KBJnlyIS7a8C4wQj
         +X1YJ4cpOisAP5xzb4ZY2v2k72xKbgx6OzMWXfdNqHiAWcVasotNGNsRH0sKczXIG8V4
         cPvDf7PKLHuu02RxmpmRhPNTDpR2SkyD8nAb012KF0f5cHwDk7WPxKjEWTkAuJG5+waH
         feR29nnjXi5PF8fWx2VSUTInStzZ+NKBbtayLg5cPRficZUZuQwRdxc6t9a997dZP/Ow
         SVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186862; x=1795791662;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gzq6a6gkghfYBMHBo7rUmEzdIfmyBieLV65dMGxy5kY=;
        b=GKELXiv1jISOGlZtPULnGAztP8vg114r0XIancup74iaTTZSq0H9HhPTj7qZ6Kfoxy
         BAshIl1DUatkLB2b2WzSrMOL3kYMPio11eAj1GLVG/vZED34j6g0bctJI0nDPWsodMIq
         Xmo3JdWF+TbyckeX01hmIdffAvcMxhTM+CrGSdibotZgvw0xTuV+FaYetuym7ebfZJjE
         IGkOegJSv99RldVaWF0M5Z7Mc404fv5uIw918qFzYZJ3SmO828imLA+QzKY7lLH6sap0
         y6emd+q+zXmYfrcQN0tIFwQSB12Wbwwl+Y6Y7yH1bg4A13A101ny+8xGcd886o+ruEkI
         KOwQ==
X-Forwarded-Encrypted: i=1; AL+hErH0OWBaig8+MazcAWYkJY1SPXj9jLgEzBQtl3e2Qu0yPwaOVN33bdzEQXsThhpC7VB60C+muqBA7S4h@vger.kernel.org
X-Gm-Message-State: APuU4Z81GHk0HMMaHpMnv/evnocf3q4eSLunyKdGzYKyCD8FeM51hVH5
	jbQs905xiPjiz+Rm8eOK0xLgD+BWgFXYRi9yweTi4RZpT/TB5BzWAIQXSeXg0MK/vUY=
X-Gm-Gg: AYBFou1smVrZojbPLCCDWvtLr/pCHXYk/Cf5Xfui7kYqoFkZBTYmP9opLZDUlT7M4BQ
	xGrEZ8XUVvcnHeHP2IsxiCKGByJSNIHMkeQPb4ZU7fbUj15BW+antpVCPoHnT8ehGJ7tpe2Mjai
	qthCR6BQ6NwGEnxzkDUks/MlB8VUXtK7KLI3OprFLHTRQdwaWbJKRRCJhW6SGILanY5vw7Voq0L
	hooGmojb2k5fNFqi1/TUCHiWKF/HP03iduF8yeqhLlJY33SLW+TxJu863nCoueY/HVKhPyq5LVF
	9iJ6obNYMFS1bkTHsmdib6d9BF7c14zpddyx0f8LRtKVsh74MO2wiUe+ofD9OxlQTvOA769bawH
	T5z6a+IhCfaVKA8q9bdOAYYcjfJQ32KTPGWl+xMvcfNuDJj5q9ShEWCU5vU2V1CKqWORWhucmFO
	JPG9Dahvx2aJnT1oeANaiAsdQ+nqMfq1gOE5WhB8dUOE5t1GHd07MhhGzxUpVX3hr+WUZ5YKvSQ
	f1k1UxwJhwZNwwvJKxKwiGdyZJMbLvDmBXhXN8NnGThGJgIeSpG0SBpKOew+vAmudZzTVAq59yE
	oJd1PDp02kuWFIo84SBtxtb+vMYGIpuVh5lk8xg/VGrIzRBvFwu9RX/5Ubl9Q9xfcr1Ivy0HKId
	6I7HjGkAfp6Zn4UPzwADyuiCVYo1HAymnHy5F
X-Received: by 2002:a05:6a21:3b90:b0:3de:7add:653f with SMTP id adf61e73a8af0-4014d35e683mr3121906637.44.1795186862148;
        Fri, 20 Nov 2026 07:01:02 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfec090sm1499471a12.14.2026.11.20.07.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:01 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: bfa: bound the RSCN event list by the received frame length
Date: Sat, 21 Nov 2026 00:00:57 +0900
Message-ID: <20261120150057.3128275-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016065827.1011210-1-yhlee@isslab.korea.ac.kr>
References: <20261016065827.1011210-1-yhlee@isslab.korea.ac.kr>
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

On Fri, Oct 16, 2026 at 03:58:27PM +0900, Yehyeong Lee wrote:
> bfa_fcs_lport_scn_process_rscn() is given the length of the frame it has
> to parse and never looks at it. The number of events it walks comes only
> from the payload length the peer put in the frame:

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
