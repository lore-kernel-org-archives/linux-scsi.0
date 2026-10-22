Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792695174;
	b=2F4SGQxvm4NAsqCE52vtncNp5IJ7WeeMYIEpQwky9vMwHETB9XwxNdeqXVmUd6trRLIx
	 Qm5XDi43fXE4QXPYLvqQ/L3wN5NfxpqgMdOq1AufSUyHFHCtUXTIncmwfSM5BsUhSAzyX
	 vmvTXtX4l6En/+9txHdB8BFgGyZYJ244wyklsAxYWrrs8NmoVaVrDE9hwkVDBKu3A0EpC
	 n3nr91bh900GBeOiAcVvIfYhe9zS8JZ3rBEsVOusSeIorX0hsfKCONWzs8JWFQMYQeJJT
	 FYhSf/xgng5Kv0zwIrFjITpv3hlBBL9ZnV1ieJbLZz0FPQvCwZjVJ9GfgU/MP+69WrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792695174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AWyBv4fpq7McuxLCX2w8h8EJeKQuEsSj5BIooBiqeg0=;
	b=4stZqGdx/+ZAtb/8M4bC7P0w+r2cMKeNFXyfheEb+EUQksB4xd6un43VZsQBXZvLBOZN
	 M21mBX4S4m6Lwp4L6QqjBFZqC8qzDY9wWxbHSfs60CxjviAZL+IGze6qEiTITvkyjTJaR
	 jp6QQ2YuA82w7DtV4FrIGNSZFi87aF/ufmLHYXQ7VXKsN6I3JS3JGUIcifWplTRWPZ0Xj
	 R44b49r6QAHpNdxIrPDtOcaM4/QJkS3coT8BCepVlOf44x+5PkSjVrIwPISjA6xwtuTTe
	 V7s4a1L786NgvA3uBrR+vbs6BhjxCwdRq7W3VzJEugbGzPbz//nlOXQnguXMzOFsnVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R3IALzpF;
	arc=none smtp.remote-ip=209.85.222.54
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD4606A33A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 18:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFCD4606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R3IALzpF
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-9907fa1d2d1so48882241.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792695173; x=1793299973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AWyBv4fpq7McuxLCX2w8h8EJeKQuEsSj5BIooBiqeg0=;
        b=R3IALzpFfM9q2REeIpNq1MyfsrkB0pUuq7o7l9hl9XRIDRt9s5HSHTVJlOvLflYF2o
         4vcMymW0nior67vJggTTcqFbeAe3PHWnx1stsHLHa4EvjnvcOc31O3pP50lJglYBqEo7
         9R1xzovT7BQrQAENWN+58JTGi5qH8mm/7gbU0Oh8n5mg38dFI/OmlM8o19mmEVc7Ldec
         CIpOUMWfbhduiIHrVYPEfpu+54ouaCCWNDCWlWx8MTtbg9SJzqCcF1xZws+VDbdH+6mX
         uDVBoEJYibe+pAJCpRxoV1tjJ2/qsfbe19yblLSiD2hxepP49u2C9esuVyYDpwegwIxV
         EvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792695173; x=1793299973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AWyBv4fpq7McuxLCX2w8h8EJeKQuEsSj5BIooBiqeg0=;
        b=uiVTTTwr+MLo7H7DGbN7KH4ZiGni2NBLUG9p5nYOfsqyyxtexuT0qFLG/XiDVyJ4b+
         5qQ9WjsJs8D+tT97fDeqiPOx3Foh97SLTsgPOwUDd4D9K5Yz6UAHNQMQo5qqvn122WLn
         ZoZ6HS6IyVxIGVLaZkkzk5rDcnxp7wSmdxdbvt9tfoJ5USYjK6LK0B14RF0cyWlCQDBa
         6xxZoPM2f6bX56kUqCFIV3wA6Xcl+SZExyJEsXqOab6K6cQiZPD6xdXOFv/HnY+1KipR
         PNpREYMG2cx/FF4DTl65h0A3XFq/DVPioZGqNuImcOxkHx+VcfRb3c7TYyDdUpbKbgDm
         dFEQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3LsIksfnnaZFNxSmlmSYhdXQ1qDp2rYBuSjfQ7CPSPgoKGkXPDRn9xETzSeWOzQ0AifQnd6EwPxe6@vger.kernel.org
X-Gm-Message-State: AFq9FYLmD6H5/DNPRvRjAIP7bjqyBMTYv/gNQNCWRBzMOYxU7SvZ+POe
	dtNxxau9m+Q5VQEvI0BCdIWjHcfGCEUCmBjDv7GYQiP4rndVKYZ6aK6p
X-Gm-Gg: AYBFou2EwzfuWOWEJhUtvW3hZbtIPDxmbmvINClg9rK/nuJZ6ot/hK/4kjeeiwID4q+
	4rDlEy/NyZkeqQNwvkFCxT2OxTw8rBxfFq3BOVNroN7wCKwMhrRJgQTjzUvLqgoYZh/jyd4MCqE
	MmiHMXvfyk9hH+JiERRgluPPGOohekV0I4xHa6+EVgMNNSu0TVQFL28QPb1ZC9q43B5y50zLH51
	bf7HDA5W3b5HtFJv0U+IYotJ7hzy+i73CZuIx3Y96EhL7qprLiANUjO9s9/lCqZMWrwEeLzsvy+
	iGl+o2WZTaY+ZFSZpj1mXAz16ubUbAR874DSYUX2Ig3snSexLv1lpF1vC6rm2sx0ViCY/XZYTz0
	hlrX23O1ou9DmMj3ga98nNgtdVNH6tZRFTAl/4+WMIuxq9Fm6wEFpcKHPMqjNEdaQ31CGJJE+st
	2Oiqh3BScZVpz/Dm6P88gQvK4kLnZKySN5S5oaRzDer3BwiKsCE4ctIzBrE8ppHFHRpiQGYnkep
	YfCDztDZLUUruDJmGtuHXtlj3v/fRmS17ghYXoofVnbrUl7HcsLt76IJN3lzGVn906TPXpWThCR
	KwvNyR/afGAmwrUeMqnI
X-Received: by 2002:a05:6102:2912:b0:7c3:7286:b7ea with SMTP id ada2fe7eead31-7ccc334dc12mr133557137.17.1792695172635;
        Thu, 22 Oct 2026 11:52:52 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec124a7da8sm508980e0c.5.2026.10.22.11.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:52:52 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: [PATCH v2 0/1] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 15:52:23 -0300
Message-ID: <20261022185224.60700-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022183658.58090-1-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
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

v2 addresses two issues raised by the sashiko bot:

  - PTR_ALIGN() rounds up, but the assembly's "bic r0, r0, #3"
    rounds down.  Use PTR_ALIGN_DOWN() to match, otherwise an odd
    on-card offset shifts the entire transfer by one 16-bit halfword
    and can walk past the 4 KiB card window.
  - In __acornscsi_out(), the trailing byte loop advanced by 2 bytes
    into the unused upper half of the current card word.  Advance by
    a full 32-bit word (card++) so the trailing byte lands in the
    low half of the next card word, which is where the hardware
    actually samples it.

No functional change for even-length transfers.  The odd-length
behaviour is now correct for both directions.

Breno (1):
  scsi: arm: Convert acornscsi-io.S to C

 drivers/scsi/arm/acornscsi-io.S | 116 ------------
 drivers/scsi/arm/acornscsi-io.c | 168 ++++++++++++++++++++++
 drivers/scsi/arm/acornscsi-io.h |  15 +++
 drivers/scsi/arm/acornscsi.c    |   3 +-
 4 files changed, 184 insertions(+), 137 deletions(-)
