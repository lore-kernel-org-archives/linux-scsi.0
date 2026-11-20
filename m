Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187093;
	b=tnZa8c1GKlz9sMeXKsA9V08fCjdRUwvvtc6hU12anHkEXGr/tKhKtNZqEXZFoaYEFyW5
	 G6One6Nfw6uxt6h+FXXQXi0p0oOer2j+rOxL4mOdxp6b+T75TfdOHPs8Zwo9kqNJyBsaJ
	 Ubtp+CZ5dyYMHaw88dPKLoOcpYRC5y/l3jGrPAwp0YEgya03dlnkVHIUuU2QDG0aOoIDN
	 /H7KaFyxCylWMioOTaxKQS/71LYSZDB9t8ahdS7aaEulDL/rLlS7mMX6C75il0EEg2hVd
	 z2s+ICCdCf+rV/aLnsBpYof9dwO6K9uwEuWE78t84Qk2DE4ZvOmAOvkhSmT1TK4BtSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TrNB3pyvZ+lZ0OPeCFGzkUm2O6G++eG2RC/suTM6IO8=;
	b=c7gDCjU45tN2Cd2/j3HJAF7/yVG4tfJ2udcletTEb/7C8gb+e8JTky0OUgwfxxpLJWGw
	 2YaHekQVwRbaRQvicVJXLKabb9JsLZP16xYdq1mEDnKWzcGzoU+RAlX/nc+HRR6jjlqlr
	 QK2+/LOqqDSw6eEgLyeXf0IHtd5VXlbYiy49a/5Sxbi1/5VFBU73IJEv/KScc+iWoyxJO
	 f6eV8lAnfiqN4SKPGyxpo6JODxeF5v8N9sHhZWqYHRx/andJ01fAu9k8tk0R2EdLq9IAk
	 ZEqJ0N8/sOF+cKAyFRP8BGRQxOz1yc4YwY9tOogTf2hYX0bzLdaYLgJREA7et+3u8kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CV5LTRZM;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16199606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16199606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CV5LTRZM
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f0481b35c9so4090205ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795187092; x=1795791892; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TrNB3pyvZ+lZ0OPeCFGzkUm2O6G++eG2RC/suTM6IO8=;
        b=CV5LTRZMrC/kY/NaGg+Qd92MwUWGEAIsaz6o2xwnUutYQfrVl0CuL6jFJanqSUuXTE
         CoKkCFDs+LlwUxO6yZGY5rRc95T1OUG8knMXbBpBaU8TWBDvTDj9htuzx4m9rhv31b5V
         AWhWLBBBFdmQHm8hAlGnfzXgORTuXTTcoU96O85LXaEBfpq7gDVC9J2wGRIsBlqTWmkH
         I+sXlX93M99mo7Eh9LpBKDA+8bF8B9o7vkNezwgF9S6krzjO++66avlHo0mDZbuOxzr4
         3fy46K0CGmTwAkGzJ/mmPCy+KGIjl/axECXnOhxWIoctdNf1biQR55wZ/1gNshU2rf13
         vTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795187092; x=1795791892;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TrNB3pyvZ+lZ0OPeCFGzkUm2O6G++eG2RC/suTM6IO8=;
        b=NpkjepRPqcL/I8SouXFYjiI84SjuE97uLuPNN7B6BeHCIuoMyzMjx9JFGYf88GpFBt
         JNTTD2V+x8VZrMQTMR93UcQpZd5feel11jNKRHQTBBwpArO3vG0WZgCMGCFU01yvVaMB
         pODP/3BcBvQPGeGj1Mr3mVd5WT9QVNl7WxTRKJ7+5fEqGAAZrsqUm7laCzxQk625Sd6i
         B8svMXLKjcc5iJiENSxHOOVmdQlN7SOhE/LXw7FNoBqsxYqiXuPES7v4MbKOzvQmP2Rw
         Z1jXPQII0YpY6nbxmDYjIR3qp45McB/uTCqiT2D58OgQfoYaE3Hzj0n0sXok94fFD7eg
         Cynw==
X-Forwarded-Encrypted: i=1; AL+hErEBXbbo0ajlkEvDyIYitsWpUpqXE4u12i1Yd6d2rRybh+HDHN2r8k77E1pky2bc2xoXtumOe2Q2NPmT@vger.kernel.org
X-Gm-Message-State: APuU4Z+NuUIB+Rd71RoWqeTXpq8QGGutaVr7tQqECZqVOWF//s8nPtke
	BTyccpIigFNy+6YeyaeDMGUUEzyRg+x/2FmwXoCKmyy6CWBLWqMsDa1zqerLdP9F1tLwrRgVwjH
	HiFQiaRU=
X-Gm-Gg: AZFdTZferIZUfKPn1/lLeKOM15OoIXLElx38hWt9gsPv9j1pG6dvwxMxHIb8gHdGZPN
	Kx1yQUX6DwD6DnKOQWLavCsTHsoRa25Q2OMO3Er2qmupxXnQNnbBfx/+lH7bu5GZoVqtFKHZ0RV
	cp+nakk6AZYnRYKOzjBwiwEN0BJ6hNFB0pM0eqOCPesDj1dVots+tf7CNv+d0qqsnVZyGNlRYxF
	PFn6nw9E2KU4rVFE5RfFKS5ihtdBZyVn//Pss5yPnuCKwrPqxyWMYfJ1FNA/vnpYyLzRHlDokzK
	o4slFFI8xwG9YY/qFvKDzAvzmAFXwmNDUMYS/SF9kSH8uesKRZcBWsLblV9K66pOHBblzsMBtNz
	LzcN/1Gcw0QlwcULuYPoo8fLwv98BQgN71BBrtelT4n+/vCayE6WNelQexWPj6iTScTBu2TWtgF
	b+Ml98PAocDumuSfD2zoJiDy4wHBIGA7b+obVNFChN4KQMjik/MzRzWtp9jF4LjdXiFoRWmJznz
	151HLN91YdxglomrLaOs2J/gNsJW/nGCoC3Z/okUd88tidXPAv+70QnaUWB/EEscKwAWMAMWpCh
	UXm1tqlyugIiCjAn8Zbztbe+LxQt4pmvY2tY9fkHzL0cHSxF/kBOmLU5B6Qs/YCmMpdcdEsGa8n
	KCiGpCtz8pkVSHi9aiVaIlxSEiE6Gk/xLk28mamDHQtkLogNXgoA78s6tGg==
X-Received: by 2002:a17:903:22c1:b0:2f0:53cd:8789 with SMTP id d9443c01a7336-2f053cd96e0mr6696815ad.21.1795187092427;
        Fri, 20 Nov 2026 07:04:52 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1058fesm16035565ad.48.2026.11.20.07.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:04:52 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org
Cc: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] scsi: libiscsi_tcp: do not accept a Data-In for a finished command
Date: Sat, 21 Nov 2026 00:04:47 +0900
Message-ID: <20261120150447.3128910-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117115058.1955891-1-yhlee@isslab.korea.ac.kr>
References: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr> <20261117101500.1894608-5-yhlee@isslab.korea.ac.kr> <sashiko-outbox-218654@kernel.org> <20261117115058.1955891-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Nov 17, 2026 at 08:50:58PM +0900, Yehyeong Lee wrote:
> The patch narrows the
> window rather than widening it: a Data-In whose header arrives after the
> task has left ISCSI_TASK_RUNNING is now refused, while one whose copy has
> already started when the task is failed behaves as before.  That case
> belongs in a separate patch.

That patch is here:
  https://lore.kernel.org/all/20261120145243.3124991-1-yhlee@isslab.korea.ac.kr/

It also corrects the changelog of this patch: while a copy is pending
the error handler can finish the task too, not only the receive path.

Best regards,
Yehyeong Lee
