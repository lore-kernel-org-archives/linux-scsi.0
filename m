Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794923958;
	b=SM8YOeVzjbioHAma1Bp+NWDHol0TGJ0KV7kIm+dS3lUlS2aWlDQsOtJFQHJ+9pdBn/D0
	 dXGbwaB/fEsWT5L4tNKmnXLMh+9DabTkzKYZcinAd4KFto0gTJGHD+PwOYC1rR54/vPU3
	 be1Awz1svLGHAtwIf4Zd/VW06HKj/4uNYzeIoJD7KPZ/Tlh4ul//YiO4wtYC1hAH3AY1A
	 icqcPUn3vP5gxfghp4cjtkW91hu4rtCYyvCJ0WQWWNPt95hrugctkz5732U1cpUuecs8J
	 UNOyDyEZ384xT8p1UXPHet24nDYZtdL0MD+b1mXJybIW9iCqdoQct5nzmIsVKvDG2qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794923958;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=XtryOjbj112s/FbZiYb4p7ikDeRzOqgkM1BkJxQSuEc=;
	b=FabrrkK5AR09Aybi3bqjXxI85/VaUoeRjSGSERdHWo/517Xuuf4FLq1/BiS9kb+gF0Y5
	 BzwwN/NxwHy3zxf5FAhhbbTR7X5IylbTHX6Ao24m8RDeUV8lcJD7eHsgjAxW0fnUhylCF
	 tmOcMr0bS3IzhUtfuArBm5rE0sK9aSH07PvHttjspygHkNENpWO+Lju4CTTcHJHM848fi
	 jCNENHpJOtZ9jM+xR8cVL50O6rvCRoQtUP+/tu8sTS2+oTM1QF3slb5Dpt16UfFUwwzn6
	 FHCgZ+Ocqp0suv0FG239jBEshRrfwGs5/FPadpN54NJ2UVjFjI6+sleo1iE/2Tt4L7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M9KIg742;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D85D606A329
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D85D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=M9KIg742
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso2657167a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 05:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794923957; x=1795528757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XtryOjbj112s/FbZiYb4p7ikDeRzOqgkM1BkJxQSuEc=;
        b=M9KIg742SBgIQeYompj7Fh94nLJshcaEeA2qLr+rgumLSfglJpZspU5ZdIa3jTpsUl
         YRv8u8G/OvsBIeyqLRVTU1OgarHC+6pJkt2bNnZSgZH1p3yZ52hsF4uQ2TUAAhXGXwlw
         KcDu5RLOp7sSzjStjr3AUKxUow74rdR7oZiMdgW6mMEdbF5bgrNMiYSKtmdIXyo2EXn0
         WM14Sy6gBUc/8IRPe8A5rC1Lb8rIVEom49QziWaeoTBDQGNDp975CIqZrlZTw6cPQVcB
         TiojMRBKOkr4lZmo3Dh6zqnIVA2z00wtVmeaOYo/Dteoejub2xT88W2Sj1h3aXuj79qq
         r+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794923957; x=1795528757;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XtryOjbj112s/FbZiYb4p7ikDeRzOqgkM1BkJxQSuEc=;
        b=uN4IUf5RoSJuHEoxpBL9q6VSu4KwMH88m31PoW4GSIX7O7FHEmm7Otdl2MIX5njt+i
         51+ouvhkSmnhJj0MuIzjJzGy5u1duj7I812N8dVHQAdQf8KvkcUKjpzklSZP4Cp3EUVN
         7ysFe6wxXtKVwY4A1W6kbW6KRRJDcy1vK9+Paa9chbPvpiYLr1gy2KSTuKOKMpfqDRyA
         i1R/z12WJc2leVz/sHJnI81wjfDAwaGRXZnoDFCggnwyZu2zv5bSBK5gY4saz2orXg7p
         YgwEN4D1Z+p08Hmz/paaDz3f/nc5jWZgqgjLi54KTCFzfkslzIweN4CRAZHS/jcPA1LO
         iukQ==
X-Gm-Message-State: APuU4Z/3O1ZrGI04VNWssA7WSSiBYcmmESVUujMrH1IYAC/1y33VWLSz
	ruxEFLwC/kVCglauG0UDHNAbUL0pTv1P/xNXxRMIR0vX0bkoJ5m2JgiLY0jTTc4UpgA=
X-Gm-Gg: AZFdTZeCfhQUY+c+AG9Uk+FeKLwZCrdq9/40XzwNFGWxuEA151i+ShI1zYKJg+ZDat4
	mmeN5clc748HS0lplASO4jC+1N71e+AZhTZArnXB/cnxSjNV54zI0i52hdAf19VYtwsYE0dYv39
	QImUg+uO02BnuRp25BaSzUZ0LIOAg+g6BR/H2n19MF0q7WuWNz/YanMu+AYZHTzhvr7AvPWwyTP
	rqBiJEXOQtwFqNxqxEl45k1TspGzaR620RRfZGUNJe8K3FPk+pBFYNpWSXTlt8IkbVd7v0/0ULi
	v+NlHvynkTZKoKW50ayQl0lHVLJVl/UgjueVrqcc4/yLJwuRGXC4YOROfJcm4X2JUz/aieEdMfc
	OktqymZU93sVg1G7esMq/ajBTT0C1GIWvBTwm4R3BkxBzawjlI1xaSJL/fbeO0B3MfzKDNRAMwf
	cVPnbF6tQCR/C4jWEZYpDB/Tzf6+q6M+ZZFVFv5w4KCTg50cvo8uu+j7+LDcJGB+2r+VP/Nkn6F
	Hawe1QHk0P0Vr5Nflnuao2jhnoE8v4PGfACoCeX4+AsvF0FZDTaYfe5Sllgatb9xE1oS7yIYkd+
	KiAuMPu/TxsqBiYOMrXP2zQE2oIkGRYY1g2STugjpvNLEC/tSvwNhh+k1L5jD3nbG9eLa8m3R1u
	fjDDl8utTw6/835pmqSV7CWYsPLcuZMY6xHhXuA==
X-Received: by 2002:a17:90a:e710:b0:3a8:92a3:8baa with SMTP id 98e67ed59e1d1-3b1b0a428b8mr11934736a91.27.1794923957381;
        Tue, 17 Nov 2026 05:59:17 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3a21769sm11768056a91.4.2026.11.17.05.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:59:16 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: mvumi: do not free or reuse buffers a timed-out command left with the device
Date: Tue, 17 Nov 2026 22:59:09 +0900
Message-ID: <20261117135909.2090997-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
References: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261117134227.2077013-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
