Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174953;
	b=kB+fmedcuZcR9hCJs/c9kt9kLMwRN+H1OjquNcMkT8eBu6KEdSPsLF/aTHZ3028QCgQT
	 A13UgX7MhSV11u+FclO3rbrkooeWHX2NwIh8scbuVuAOIeX1248cgBAOSC1VSvTHXdpYD
	 /k/rwX17hBeCU+oj9J+F2c91NKaj0uJK2muokWIvmalxYEVP+5uDdsDLbEWo93Amia5TM
	 v97GZ97PlMUb2QK1lNNC49qxLQbfvTFfBNVYB+XGJly2T0DCr8yI9By/9rKHCQGjufTKw
	 OxMVUlP+1I1+GjCI6RD0qPADebnrbdxAorIxaAmVJqpH1cLGlovDy29thHONQWtfibg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174953;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
	b=TMUMV44x0DhBEjpdFmSdZ8kOpnGs22YL1JI93SYr1Muh+4Vr2xSRL5CHCrt9pCaSqyk1
	 BVhJ2qRd+D5Gx4gPhz+sd+ogArtDPMTRF0KvCJjaoUQhaj+dDHZeR14lwTO/hjnRYr2Ce
	 miYhFPQ7m65fsIcGd7NEjZvdZIDqgA7rX1lt0qppBqu1VJKfTN5IgxmCmDUvXriOn0AtI
	 sIFFxO/vDXG52B0XD0SF/wd/A4+YWEUz60fQOIACxhF1dKH5A9bbUX5zz12fQ9a/OPz1o
	 H7c8ZZS/YV/BR3yf7Q0AYqC4PtqlVUOJGR73KgPg6Oqax247uGj9+foEDOWVeI5372w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jHqvMidl;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06965606A325
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06965606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jHqvMidl
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2efd659464aso2664895ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174952; x=1795779752; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=jHqvMidlaK1ei4ebUo1atCXLopzzBhE/n5JVGJj0dgjUA9nSbsxIxLDErMXASdeysf
         BwYEUMicV/myp2CVSgzJxq+dKoKD7EBgvGsNo31AHSUdAELLvz15YIWstKTH1KrUsIBz
         eI0daEK50jHdTP75CgYumWhG9eCpAMl1RLJohuQEFQvPd0L/2woBufUO7ocvO7D3wkwW
         cAhY1/hmsQ/264NZ1KugI9IhrNXzz7VTC4RTRVt+bvVVxFs8CErnzy7PkEVo8Eh5TSC3
         Du1Dr4MCA0myx5ccGUwQ9vx9CdqXaZpokDP1I72Cp17yG3h9Q50xeVq6Oi9Jrl+ZZ0uN
         oiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174952; x=1795779752;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zkI23j8MahfPJVW8qMcXMj9oI+W1BwYSEzbCZAbKEE=;
        b=hjjZaiRRRXuMV9UuOxG6dscQgzzkNJEBvQhWnKlrYXOSUHQJ2QlqGnz97tG7xgy/TP
         flV+esAfxpia3kpVZd5iIIg92jbpsmAwUCix/aaeHBmp7ShOI+Qty3znAF9sbWQ2NQxw
         dMJh2ICikx8dkvdXdIUDYemUT9lHtuhTxvaxGXsv5Vj69tv0iBaH9KTFYSdZ9/Hr5RbG
         tg5Zz0nXzrMJOTYeOCQwgNK2rtNXdxN+S9G2wpKHuL3zZ+Wawo2ZYW1xIE+dvaBwxw3Y
         XJarXnOy+iwXOmmHxnt1kQ3nhlqf/I3X5vLW45L4lXBKxewUEmY5FsdOmNUYN9bGE5Oo
         pdRA==
X-Forwarded-Encrypted: i=1; AL+hErG22Jb4OuQ3v4PXpn8fbapdXZylzAlHGSGYq/NLu0p//svrungJuiD1d4qw8vwz4ReNWR16rPD9olmx@vger.kernel.org
X-Gm-Message-State: APuU4Z9plQkyCM9cbivabnXWKbz9VeWVGdYS10p3sFFSr6Y0929YLOBn
	SghCvV+ZZJMx1EZXEd6Ortkj4f3XCTzxQiskbbhLxJbD+rRkLIqoKbc9SdlMdzJNItk=
X-Gm-Gg: AZFdTZe5juYsiqj7CbJfJVyWpGYPVuNqy2ntlIfLUm0s7yNm/MiHidW9KllvtSvpUT9
	2Za2Dcztk+oPs6fb+OdgUPYj3Q5TarHdzwettGstaV5DoZf2+4rtqvtL9uK2Ur56+M+EP5hhhgb
	6T8SE89jZEOp2M9YLH3P20ZDX7GDkOcR329y0/DlCvWGVG0IdpeMRgOrEsPwoY4aAgpUGcJK8wV
	ABc4QBtFDJmpsUOLBxEe5hjwg6SenA5K3xiTOE6c2Mcxv6VNNo8WfVXvQ3NErS6hWipcVESwG1z
	6bVWYBmozlKu9ySWvf4Vbg4oLj9qrH8mrfn6k13+fZQac4GqPvDNwJGFMWjHMhMco0HMexIgJDp
	wkpFbRIvUFWM51zOf1qAgasr5Uy9XIdJ2d3m8SYAl9S+uuguyBiY6Xi56xgSRiAYadUpfb5XkYy
	pwsBnRMpFZ1aGVZiAe35xA/dCG0b0O0kZ5/XMPYW1eaJUmvRZ2EimTxRhp1nVzSV4quKrCItsIs
	Uu7HmEYYBDsmh0OyonxWqvo0EbQ00MZBVZG/uzdUmx4bGhlDejl5uC0txCz1PmS/a7vQ4W/fGaR
	9wk0KM0VK6QA4lp6FHd8SPdaD2TVOZEXUvjfvg+P6GszLJrH3aAqMKJg1g+xhOWJ2HbDvm+BMhd
	9bOIvf5cI4Wt5Z6fC2oPCg7m/qhH0X6xg0xDE
X-Received: by 2002:a17:902:db08:b0:2f0:3e48:8cdd with SMTP id d9443c01a7336-2f03f16acc0mr29050645ad.46.1795174952262;
        Fri, 20 Nov 2026 03:42:32 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dcbe3sm13292325ad.28.2026.11.20.03.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:31 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com
Cc: martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Fri, 20 Nov 2026 20:42:26 +0900
Message-ID: <20261120114226.3072154-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
References: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
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
