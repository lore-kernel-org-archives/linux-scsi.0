Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794950080;
	b=GIEHvEA9n6nbh1QglUs6HbmoLrjfeFLdVFzjLLwhGjw+6vOZI5mPME9M80V3NBLsZRo2
	 Ti94WX3AaFKtrh3esP0D3F5lOVq8Ec+nvnMFNcBlszfMASohRvucI0o73/CpDMJRk4Q30
	 b8Fi+8QNf3HYHAVKvDQoXVwuvdFgkiVFek19/g2jhD4AV/sB9Wp5qgw+WT4b8yJ/f+1j8
	 hqvCGsLScBURB6Mb1BFaYjMvFCnD/WZSD6PhMQsIjeP43Oe6u0wFVtw8DlldqTsvRyh9Q
	 0jD2I52SkxNCxkd81HVtow8GSBYbpGnmkfD5U5alEgg91HbkZ2r1AwF980QvHFxM+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794950080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
	b=zfHX7p5kKg6EhBtNGBk6v5Uqb5B6lGNOvhS3KznHk+hiaTU0q9LKqwwYwEhTNXQ8DTMM
	 eRrGW5HfaYtWd1E45dpZ8suNzBhub7ZaQ21GtJLYhPYgFdRP2ExTwP9GGsver3L023yoD
	 rzarlzwxg6QOWcD55+LlSnIbw0lHEGVjnyIV+5rxW4brKDNlFAiq7pn7lx88yQnpYRbdc
	 XNZmlyPf3HAFyMuKDNXAa/faeZrKAhIHB6CtEiHm051BGE+1w6UaD8/V809GKOxJ8hjlS
	 IY1IMbE2mVH2oRrn82uD9wSsjJBszR8XRzq4ioB+uWpVjIhUuoDFIx7W92xbMXRM4gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=krYuILsW;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B329606A32C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 21:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B329606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=krYuILsW
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b16896b8ceso93232a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794950080; x=1795554880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
        b=krYuILsWHqhA5Gmq9FY8UN0IZeD26nP56MxavkHr6MCBWjGrWmjBYCd9Za4K6QPFHq
         VdVPj4+g5OMw3YwQVoJTC17H8r8wtxnoNxb5g8/JF8RQWj+Kfq1hwLjq88OJwjeSyS/t
         nskWICf1Om/CYkF9tortc/3/c+HAFHyjtUEbSxwyxXBE2CnanaEN4BOgvNWtjGH2tFHB
         085tHqjKWG++JuwSoX0S7e67Jc0PShzi9i1w8RSYwOhyCKBHau5WhouqdM5BFgDJSm/W
         4ySxJE0Xd+66TWbiTgQ3wcCxAnwWrpxCW2ESUSBvAX5y2D36oX7Qwl9FY2oszoaVugCe
         tqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950080; x=1795554880;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
        b=00NTwVCJs2x27v67/uNumdPWZZOIspCxbrhfbZIZEb6xDz5bAePVZlBH9YoHbaOxWa
         hs2Bhr5VeIJQpwRQyAOgJqDfkIDhCrrEkVxyj5kJmXLqbfpswPafvmYc9DJfffVFONoi
         6VddxPp4wh/Au5vDaH7/Td0vg2SzTw0SAvPlyPVKL9E96D1sbFQ9yXEYafYtppU3gW8a
         5DuW4MAeOI/pgq3jMLShf061/XdiMficWaXyva3kIr3rLmPW3CPG3dcHyDHZHx5Fqh2r
         ojzYT1sg4JMAttJH1Z8oZ8uUmo3J7kCQOBsp9I1DNaRhwthh552O1wD3thJ6Df7lsqC6
         P/Qg==
X-Forwarded-Encrypted: i=1; AL+hErH1qevqwwRsSddIf8nVBlI7r9Y4cJagONs4k0n5IK94PE8Cz/p6Xot65bMBZW2qyWo3hW/OaZld2Hot@vger.kernel.org
X-Gm-Message-State: APuU4Z+vEhAMj/mZElArYemQdnBxGUyRa/QXexgXfBG/uaXm2iI2q7cf
	Im0JU//81QPo4IQZwv/AxHWBNrwnOVBCR4iwikrRj5N5UNKKR7F5zaebSsXay9QmcqE=
X-Gm-Gg: AZFdTZdWRIcd7x8txKMVJzmKlUyRf3JyaF0vYQFC2IAIoYKkZLd6aFzge6RH9w+R0tT
	HPv7jupNBYcI+L3Adng9j41Cvho25aacHSB0qmOrWpg0NN6Pv6XEBsIPyVYLV4CKYVjLRF0X7Ri
	ypWkTzCDEOSNVPES3RpSbJEyBBC9Bt7782/bCk5vWQw7MqsPzhS5CKZ8DpL4mNAaHE9oJGG6xJq
	NrzktefzMVxeIiasmIu+TxuEfh5Dlqkwc5P9KiyXaiz0qjMYP8h7LxJQ6HMIHPhRCDI58y3cal6
	U3wl9JXWaQSKTqQasaanV20pDKhRsT8qWETlD//b7bOIwkLp2PvWBqC4tth7/RkbiWkF54JROGR
	NK4jG3OAQptijTWmBGWtPT3xee9L79vTWMJwamsp83PTIAxabLFe9bigP4kRj3QFJDIvYfpZp8i
	pMt7JXkQpl/FT2jmBAggaGTAPge18fDEk3wHYa5R0pdCtthD9FmmKDHGjgdwkIbs+SCgbNKBskN
	Y4+gmPV2A4Ron22G7lYKMOUzZZus75H57i3xZvPxjVzITe2c65/Z7UkpYHX/o2R+WSc1e3RRRA9
	LyJNabSqaZFfIrqfYiv3TCXsnhDbmewrzs80SOeRDTNYFaXLtp1dFlUQrytLoSKusob2SIntlla
	LksFd9+1sRovAir1Fb1At8VadL5Lf4fnUZxJNpjjbuaYj+StDzL6AIjUbbes=
X-Received: by 2002:a17:90b:2b4b:b0:3b3:be94:8dd9 with SMTP id 98e67ed59e1d1-3b3d07b923dmr540431a91.27.1794950079690;
        Tue, 17 Nov 2026 13:14:39 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac2b5ec6sm5772336a91.10.2026.11.17.13.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:14:39 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Wed, 18 Nov 2026 06:14:31 +0900
Message-ID: <20261117211431.2132978-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
References: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3:
  https://lore.kernel.org/all/20261117211346.2132827-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
