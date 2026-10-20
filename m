Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792526384;
	b=Z745n4D5hgYrqB5MfZfqR4cGmUAVARQKHRZ8hAou4033hGlBaC0qP2q4tVw0WwvKtfXn
	 m1rZkTuanD9iWWG2DojrSFhKn6tTWWfQNAboE0hBRXiB6947sdnvfI/scen347A4YGsMB
	 s8hvy+7ZkGmgvnSUVgvNutljwOXabQl4oR2Yd8LZvHpeNFBZWvu3enf0WEk1DZ0tCbN0t
	 ByrANsDadM3eHVDf0EcwSV2kPCwt7nedlC95A7jtFiX54YWGNZIkOKO1QFYuHxPB1EAzk
	 cNf63+P11jcCSSwXmhMUqNUOZGEZrjNlpDAHorSX3qhh0JYLvFKkIkOKK1kzGTvUuew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792526384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+eR0lfDXlGBkQITg/93Hqy9Hz6un2dFbfB8Q3L+Xa5Y=;
	b=RmD4QVHV76igd09nlrnGg8pGaZiQazG90CF1X2sgae59x+JB9xjvKrlomCeaDnIMOVBw
	 xiva+AWrudfL5tg2piygABFe2k/6qmqYCGeMFbFUhFU1n5IAWG0WYtiqX8ezXTtddbHIf
	 +PSX4/tDq4kdih7Gq/kn1VO9ErNsjcqn4xb1ini7fMjHwOB7IXrr1677Ae2z6h88q6AIk
	 myfoUYkOj1j0fs0ZjuvS1ip4NqSwEFSuBHgY8GHMQ2iz1UEEKmWrQ8hnGIldypI+rKewF
	 ES5AbZhP3cAdSHnvrz2uegjLzehrNtNTw09Q5/ZzrHF+DlQByX03HjWh0s3bDhUH71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jpDb8266;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2101606A31A
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 19:59:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2101606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jpDb8266
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48b0584ad71so8553f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 12:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792526382; x=1793131182; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+eR0lfDXlGBkQITg/93Hqy9Hz6un2dFbfB8Q3L+Xa5Y=;
        b=jpDb8266n0eF8d/i2ZXHKfEYgqEsLR804+WEEzWiZiRgJmg9DmrtWWJmPob4hSs7uf
         Yc8Kpxcwie9eGJiuOcy4end1XQ8xzlc5Mjt986wQpuK1NA49eQ+uX0yAwXuYaf5XRKLp
         Jap/0yRqHi3E0Et4qP5I2EgvTqSrpadzAfaY5lsVKpYm3y1oOWqipSuvLYDYO+489Le4
         WcW7tQW8E8yz1s5X5zkHJ1H9WxqgnHNfbo8OiesEx6UIF3VlB5ed6bxi7Y/LroCVIYcr
         UGv8CE/ezRbG+1+qjg3g3qdiSD1Qrzc/DW1npAsL7PbVYYEz+LiCtSNV3IzRXU+nOgVy
         GBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526382; x=1793131182;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+eR0lfDXlGBkQITg/93Hqy9Hz6un2dFbfB8Q3L+Xa5Y=;
        b=JPm7miPu6ZMe8KyZS56crMhJuIQyaFq1s2pqjKYx5TMWZv2RDTRM81O5LPT7Zd1Cl9
         RohTjx2AaEr3HGEM55kqR+/n2RXk3ib3IMRr5vr7J01prpxx8g1XCMhP5C7l6hkDBW1d
         OAAoUlfmuzo452bihHbzddldNVuLtZB9+/ibLN2e1/ck2YjECUJ4VHqYZ1hdfXWW/ia+
         0WZO3OQJCygKeES4s9jkUXlA6JdQnpL5FHHjb7JoQl/9KGW9+asHKiCrkh2X2jEXGIB6
         oaV/QcEwshbWuIxDB2n7/rR6Bf9MpESGyAXPAQDqV4oPhjWvulFtNArapAQ6mVVI4xW2
         4rsQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhul5RWixSmyPzoUU98DdwIT70tRvULgUG/3IZl4REEvVOZRfVJi52Iosplq7YiSEND/QRA9Q1e74z@vger.kernel.org
X-Gm-Message-State: AFq9FYJMY/yrKVBM/P43me5OE3EIoNuH9eBqSNxdXsp3KkQTJcTl9uJX
	oxLvLSsKKsowa7tiMqgVWzrmsltiisriEnKIWVFhDUWnCSbVauZR2CGv6aB8IlQY6uyA1A==
X-Gm-Gg: AYBFou1wTiRBL6YcgTmSA9CIDN5B3q0PrstNXllI9KBRr1dh2DUOHCZ5vKMiWzFhtF4
	NoXrRbxa46rp8yW5AqFXGOC5s6Gvdcg7eSHgkU0NFiZvGTvBQZPqvrRM3aKA0Ql++eE40S2CpvM
	sY9kypipmAJ9Ys0YKHU8mncYCxAMCHDgKI3DL3i0AFibAjvIqWBP0HhvBa5u60SG65aWxG9ChFm
	pw0KeF88Y0dW+muWQC/P/7JePHvYbgjjKZVYnts3gLamXyGp6S7RvxxWbSiAiwSOWmg2XP3nbHC
	/E7ULW2ano2iSB8ugLPfoIPCOe7vJLwoQ54b9TcUchze//YWc8LhgpFx2NwXBZOd91Eqtv2He17
	jzQM8LoJZmrzJikrBbAEsg3Hu0BAxw41ANd7xMx6gU+nooZe+u36SltPW3ElKoLP3jN44Jmul/8
	q747K9L0R7wb6Dcfuf2PIVdtOI/8iZz71DOIgvwgxIjp6mHjViU1QqfHYNYBO7oXuWgOR/whsD3
	6S9shlUnBt8
X-Received: by 2002:a05:6000:1847:b0:48d:e5c9:39a4 with SMTP id ffacd0b85a97d-48e07f9f0a1mr23318111f8f.33.1792526381890;
        Tue, 20 Oct 2026 12:59:41 -0700 (PDT)
Received: from ADRIAN-PC.lan ([171.22.87.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581f412sm594323f8f.16.2026.10.20.12.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:59:41 -0700 (PDT)
From: =?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Adri=C3=A1n=20Garc=C3=ADa=20Casado?= <adriangarciacasado42@gmail.com>
Subject: [PATCH] scsi: libsas: Add __printf attribute to sas_ata_printk()
Date: Tue, 20 Oct 2026 21:59:34 +0200
Message-Id: <20261020195934.250768-1-adriangarciacasado42@gmail.com>
X-Mailer: git-send-email 2.39.5
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

sas_ata_printk() formats its variadic arguments via struct va_format and
%pV before passing them to printk().

Because %pV hides the format string from the compiler, GCC does not suggest
the format attribute under -Wsuggest-attribute=format, and callers do not
get compile-time format string validation.

Add the __printf(3, 4) attribute to sas_ata_printk() to enable compile-time
format string checking for its callers.

Signed-off-by: Adrián García Casado <adriangarciacasado42@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 61368e55bf..53eac56c3a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -372,6 +372,7 @@ static int local_ata_check_ready(struct ata_link *link)
 	}
 }
 
+__printf(3, 4)
 static int sas_ata_printk(const char *level, const struct domain_device *ddev,
 			  const char *fmt, ...)
 {
-- 
2.39.5

