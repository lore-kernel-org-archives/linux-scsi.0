Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174940;
	b=nPX1AJmQkEvxCT6Xf9lIOsYERnfD34g2J+cBv3E8lW5i8p+iw7uUuIwfUyhH31kGlby3
	 ZWYu7dIj5VXja6oc55mw3Ol++y20vMexPLlyXshHHIW9LoB7jLfoShS/XfQM41/t2hutm
	 3jqG+SN7rn2wYP0K7Pu4BnZ2mNRdDEpsp2fOWgA5RWu9Zq8t+OlL8qJ3+ybCCrej0VYR9
	 TwCUEWCcUski+4Urj+OsRMFapLbZSMCySziAIvUSgv/FfxjMK8alE1UBS+neVYQZsX7Fe
	 3RliSTIiDgNQb2ZdywYTS2L6RPcyhLo81EnFBWKquTU+GbWkZ8UF+WGrHf79IsRw98g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
	b=A7DBsRFM/BHL1wAlAS4e9zXdSlpRH3aKdArU0DUqhavQJFET2DceVZrXbVcqvwQM1yq0
	 D0HhogxYfomauzLBAN4qY1cth0hvSYbbf31RYYISGhSq57aIBNleSuSNUzhA7syCjoi02
	 tdWOzn0vblCo9wV9klq111jv5Uh60lWifS/NPmmX8Vkb160O+/Nj/6wWJvmkqY5y68W6v
	 sMY/V/NF1aR0JhAMAOPcqzkDe+OkZ60DvZzPIYxSgv0+thD3dn4DP5QhOHFZdcTxqUPKx
	 v9+IZmun8pTZrm02oe/aF6Z7Ohz1ww/RsRfk13zEGsMhwqIeHtW8Abjge2ksPrFOW6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BF4CQWKf;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A529606A325
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A529606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BF4CQWKf
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cddac941ed1so330478a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174940; x=1795779740; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=BF4CQWKfllG2NN3Fwaxi9GtepK9l5O2yFjO5umyljvitcuxCX5XaEBKGdxA5iVZnoY
         qCz60f3tOEOnfPMnw5JY1JG/AVpOxw76pfgwYQj18wF4BTN6I5OeK9/fYwO2yT6Zaggf
         9CfiN4V88xPUS0KXz/Rut6EK/Wuzn+PBa/aPAj4jjE+HNizoiWVAQKrOj9S6MUwtxi5b
         EoQY3EybbQAZ2TpvWYVp+GF6as2hwfgiOHFrT5QXd11ZIViQTJhlAcuXrwGC6EHHZ8YN
         sa29KToNiM124U8Xk0RL0UAPSFTuz3ceD1JJlUt3IOdYxcQqV2kNrKMtHKEse384Ur5V
         LMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174940; x=1795779740;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=SH0R0QrkGMCVrEaLLpHtyZxgzPcqA4I3L2D1h4h5Eq4TDQMTX3KWsOLjjKGLJjvhns
         n9KW9ZkXi5sE/ylIgoh9LRMgk4sHyTjWHiBjdnfrXmbLB2dril9KcKIDjSptMTLcO/0q
         EEMS5XEvMl5vf5+i6vz/VSMlBpbnF9/sZ9/0lw/Rv5FC03sWbcCUZZ/GmRYujYmLIc2P
         +8iip/xNUGcgRowaS88xAcUa8fiO2fMhhUTZRMGgkI9UfqQrK9Tf676ajnZHIXAm9HFr
         bMHQcjRIdHt2TRDNAhd0QnTlgyvqXxTQ4VgIt+v5qmWjf7lnsdQUnF9NHEXLKQN22c9q
         dJbg==
X-Forwarded-Encrypted: i=1; AL+hErHh+pNxtEVlf+KK+SfttLEguNcl2pNSjSz7VdZZQ1h8bUAY7CEE6EimxC0EGtWgSr4bbFsGpr1+P+C5@vger.kernel.org
X-Gm-Message-State: APuU4Z/CRXQjRc09ej2R1gztGMI4HTV/wdxVBH6w1/UlMhHlV7c8WFsX
	BkdZVBhSunK88GvVlTru5vWAT5fndIvJAfk3zOn/jdA4t8xHBbMvAYLmF8wKXke6gp4=
X-Gm-Gg: AZFdTZdxK20bqeVRzhi1i5yaeBkl2laQ4y6PVh7u5OA+geNfbMgzdV4v73fvGLOJ8B1
	uryD0At4SRcMLIb4/1EHpl75UUeov+lGztSYBIwMqwpPsMDn85upKLJhVT4jOk6djxLVP+YQV+7
	3cvYRolUntatV0n+3Nc6HXJPkC70ceUv+9kk6kLrP581rntCcnJ+b8xPhaE5sYynOQf4AJF1znt
	KKRn5+ItNASbmJSIRluc7OaZ77OygfysvYNgwTpIXEDg0ly9gSlCgPjstHed3jA0we6AQSaP/Jx
	6EdgXjaD6Y01uwb1O29php0pevP9lkzZZf22jdQB9UYjE9frboj4dJpAHkZo/BwGHXlvWfyKq3o
	heP+DgD2DYkpTW8NX9nWEHpzCo34NBR8cPzEgCY1yrdgAw2kfzPgTQ0NH2t0Pvp6ECqN9q47If/
	7D/x63nHshfGC33Zqw7ORWXZLRauM39Fqx7cB7hrXi+t4aBs6F5lMgtpKSa8fPqrIufYSF/BKfS
	hfpQGEngxjq58Arv816HqB4VAOY9RqKtEpyZGzoWc8OIkn7dQ8n8OcQYRLVW1/+rTJeosPQgaP7
	EZDpCTSg5dSZK7eMrvGYSXuKcmSIv3Et+mF8qMyPPGaOp/oZFwD3r1XNNNJ9q7mDvC5F0Zsx5HW
	KBjVBWD7JAsk4NuOtFcgu3WDBXsof7TPZwyq6Ug==
X-Received: by 2002:a17:90b:39a7:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3b41c9638b9mr2307114a91.40.1795174939658;
        Fri, 20 Nov 2026 03:42:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecbd0bsm7162669a91.15.2026.11.20.03.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	cleech@redhat.com,
	lduncan@suse.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 20:42:14 +0900
Message-ID: <20261120114214.3072124-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
References: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v7:
  https://lore.kernel.org/all/20261008063248.767676-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
