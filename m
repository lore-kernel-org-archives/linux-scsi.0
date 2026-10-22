Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702942;
	b=qq7hOS40ZUzr/9p2bNjAXJ/OcgV/hFtzfsmHz4nptib4Ih9+3FKar4QQX7VQHCXlxjrY
	 NCoIgD5UIObJzOpd9+JrqJOocEIBsIa0g7F5pxp9xdzi2iRG4HoZg4BkUynEur+Gqx5Bl
	 hm923DP6BjBrpPunqzCK1y9+cB8BYRMT6nqZU+TDIJ6n1cHL9eYzndcAiz/Rcx9AMC6tL
	 l/nkryLz17HwD1tnrCdS1ObEGwdO2ZVJxPlGlMEUp9PDOZIdzduKmqY5tg4lrzwBdJQqQ
	 nnsCMYaekALN/tytlLbTF7rRm8+aoPSn3NzL9s1zrZ+P3Sy/6cYkbPBFNgKwONqwtPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702942;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KckalmaIjViMDWQxTjgX00osy9mL7j2AOuEfTdMk044=;
	b=kQkTFoYO3/o27lHQOuuYAK0jg9y13wdkY7YI9RNV504yEKxEf+wPI8EdedhrHXKMcI5Q
	 8WIQxTqtFlxxMZ674/GJY9d0PIDbpNUqSLG2nldvSRCu8BxocwwhdrAP0hqNj7AOG9Ff6
	 tGB0EMf4FsoeLzCxv/rlrbfyjXxV0OciV7dIWqkKmNE69AbqN120Kkc3Nl03YzZSi0R3T
	 3NdGXKPBK3P1BSdHK10CXmlCPSzkaR6TieW8Cqt13YtUXs4TgOUSclLwap6n8/xdMvG4c
	 kmliA4AD4RX75npuzIn4lW3bRux89LDOzD2qI1Ut+p1WwuKV7YygIOUHUELnoArAKDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=soUYr5JY;
	arc=none smtp.remote-ip=209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508AA606A31B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 21:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 508AA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=soUYr5JY
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-980c4258105so166658241.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792702941; x=1793307741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KckalmaIjViMDWQxTjgX00osy9mL7j2AOuEfTdMk044=;
        b=soUYr5JY5uplH/mZ/0zOpfoU+Sb8eutMupP192RlLGpXHaf9DrnCAprQsEjlosO2Qu
         mwo8JidaSNE1M22wTCXc9BrQlgGE74SrPzIBmxAKfs8cl4XMqpadt9c688G6EGD4ZPLe
         Gl65uOPDYMZNm6p2I6Uqr/6lYn2TZaF3bWTPwPj7lBZrDmF9CKQY9fTU7oQ0wNlbCSEf
         8BybGMZIw5PjUzURhaYtBd9PcaSoaGbZabRFmJUCBwhtxPnLGG377ck7AwcJUkZ/rr+4
         DxaVXydh2EDW0s7CLIOFIktyoCS4BStTZVbszWmZPLvO8nMGwVbCZHWaKvr6hHuqtiG7
         MLhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792702941; x=1793307741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KckalmaIjViMDWQxTjgX00osy9mL7j2AOuEfTdMk044=;
        b=r+ljb1vC9EAyQtljcp3VO6P44FiygHlznocd8uUcich2HRt4j9Sw1rOD3lK0VMOeIb
         abR3VgFd30q+JDeuHNIxoaRNSj4WhPDJtXnNoHI26L0reUVIDFXfUe9hCOsW6dy3t6ha
         A/Grqki/Iiev8BtFej0Us45gEvpXagtOnCUmDZ9CyTxXaxTPLrvuXlaVc33X/71+e6t4
         SNbs+roIGD/vQKUg2MXkRg95GgSh4UHd+ZOxAH91SvO6EPAewqygH4YP/peVtOF9VXR7
         ibzNblUiWuM2KwABada/bKJwLguzMYuLmDZhERfwuFdeAQqz9tFPM+r7hebrP3oibYmh
         vJrA==
X-Forwarded-Encrypted: i=1; AKwUvByGgaBZbpZlCQL9+X/wBJJDw0saK9wvHgWtghStZ8oPjO/fmVMXKYUExG8liV3Vt7iEwjxN3aCp3Ky8@vger.kernel.org
X-Gm-Message-State: AFq9FYJpBNfNUqcdrjp07lEPGOe7sP39X3+uoZLrOkdyNYv5bE2yD8Mb
	yAHo1kTJ6rPGU6Cp8xYiHygGFMUv9dHutX2z2yzVg3QWRy/pDz873ruI
X-Gm-Gg: AYBFou39HWyi48c06B7zqQPVlFLA9qvJlues75NsAGqwjMhTpBCA6pSHpV1pQ4kMY8H
	FuzdmKsIVT/Xi/lnvSK5nSvJkmXZ4N89rV820LtO4UOBy4WVrs78lW2tJzgYBH0r51nN4uTO5/n
	iEl6s/nh5jtS7WuluapbpzGXA5rKPYlrvTt2/j5qU4nWnMalBa3l7CY/v5c5gx5rMruBkIQ03ul
	lVfgM7/6yoVLsQCrM9kBBI+ozor0iuQTX/SfK9TuF8yYkS1R7WUaAjCb5vkCvr0ZeAoWTkJ+gg4
	ZQ0SnOLjGeRGxhFBRjUjkaiurxZnOn/Nx3eKWcShUB0oZhhM/CF9DiGjfq8yqKgxZVNyTO0mBkL
	Uiz3UDelMiTjJJJqNm/XMRgNo6cCZv8an25OZcaC3bM19fyuF2lW0z30ULi/jpcccRLPZ2SSHAC
	S7zlC5euvJgc2IARLpNyPt+4WfkP8DXxCAe0xK5Dy3CCHJ6XfJWDfpqQk1RZ9tyjrzpcFj+qRRk
	rHqqboin//T/r7cKb0MF3Hg4+ofM6ov2ZXSnddXNDzloh7V08yJtJJsMunJPY8QzMsnjYxB6div
	iGDlVLATUSXsYcmzf3zu
X-Received: by 2002:a05:6122:4909:b0:5ea:cd69:7cda with SMTP id 71dfb90a1353d-5ec14a6ff12mr25880e0c.7.1792702940525;
        Thu, 22 Oct 2026 14:02:20 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec13f061cfsm303526e0c.11.2026.10.22.14.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:02:19 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: Re: [PATCH v2] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 18:02:03 -0300
Message-ID: <20261022210203.80641-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <4e2383f0-9791-4840-a4d9-93fbe51b7a40@acm.org>
References: <20261022183658.58090-1-breno3011alves@gmail.com> <20261022185224.60700-1-breno3011alves@gmail.com> <20261022185224.60700-2-breno3011alves@gmail.com> <4e2383f0-9791-4840-a4d9-93fbe51b7a40@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Bart,

> Shouldn't this "while" be changed into "if"?

Yes.  After the preceding while (length >= 4) loop, length is in
{0, 1, 2, 3}, so the trailing loop runs at most once.  The same
applies to the corresponding loop in __acornscsi_in(); both are now
'if' in v4.

> The above code can be simplified as shown below, isn't it?
>
>                void __iomem *cp = (void __iomem *)card;
>
>                writeb(buf[0], cp);
>                writeb(buf[1], cp + 1);

Agreed.  v4 drops get_unaligned_le16() in __acornscsi_out() and
writes the two bytes directly.  Note that __acornscsi_in() still
needs put_unaligned_le16() because the bytes come from the low
half of the 32-bit card word and buf may be unaligned.

> Isn't the above (void __iomem *) cast superfluous?

Yes.  u32 __iomem * converts implicitly to void __iomem *.  Removed
in v4.  The cast on the earlier 'cp' variable is kept because cp is
used for byte-level pointer arithmetic (cp + 1 must advance one
byte, not one 32-bit word).

v4 follows.
