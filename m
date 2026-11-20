Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175071;
	b=F5l7WHdST0fL276jFDqIh8m/vzo2QmAnvrbAflTvzrG2X53fIZXlzOt5PKD7GWODCt+C
	 //Uk7kkY2Bu+32BSSTin2LZ+85QHlJoh86kySeWEK/FQvofXx4DEk576xJZhfoHYA+YH3
	 aK4kXAmJL5ENduplPNaeR+3tQffq1TzzGlpSbz5imyz8Ui24ZsU3rhmNXZ5b+V2+htyEk
	 04GgHiSVGzOb64HKUnOcihgzBuC7qyJzsBl8KfvB+EL8LpPww8ESEFRlNT6DUPyCHxxVV
	 9CePdK+yAmXJG3RPYdvP53y44K8MfM9b/X6k2cCLOu43fdq4TUZsO9Wed7IZEJHLnww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
	b=NMDAwVrZBNJSPXuAYOF0gRbdtR2bZJQLf981hbzdKTOyV/XCHj/UefMDUYEEP7pD42x9
	 1sJo6z+0dQONPtyeFR9GA3RHR2dyNDJ/V9b0CZ88YKqO7b1jt9irlATFcgxuI5S8s3Op4
	 FB7fqTwNegfl3vUA6Ik8XDbZ2G4R9JMgNAeKEVnUpWLsVlAn+7ZJEOVXDc8KbIc0Utd2M
	 vlc9L96cLu5BabI4juW2lQ0i28vvGBT9FHS3Lr2wCB7rE+lYiqO3YSgZiKp9UACz2mz5B
	 Dihz1EWRN1QPFbW5kPOiVxWV58wDTt/6M2DWqMxGg6LuuNELLJZ/6gyTk/fQ4o1oJhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WJxAVizL;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73837606A33E
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73837606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WJxAVizL
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b68e59ab33so657396b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175071; x=1795779871; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=WJxAVizLYwDKo5UPutscYMgUR8/elpXT2Aj8JtmYF3cjjfdpXMq+C2A54TzX8ACypJ
         Ff/Fzdh8KMGbm4aOONQzmjJqEihV5jFKpsGSFPvgaSdFeqfkMQ6YqCdZ9PtOyPtuEMu9
         G+r7LgvcTgPYsy++svXq5AIcMDqKPvPi9B2xqmpWy7RQqIp6EkwjNdavApPS55iKD0UP
         V0Laord20XXgbrknfNgBFb4PPPVIaWQq0DGvArk2frrN48HpFOTjTrloB4sUhEdQS0Kt
         hTSvVdTQ97ib1nhx9ynd7eJFjczSwXfBvN5K/jjDKsfELopeTxfNrhF7ZAxC5zlXKnon
         /ZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175071; x=1795779871;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=xY94+QHs6IzNBNw73pt3Sml6eONBRX5hZ9uTwMDqy7MDv2fOv24qNlzVsI4hH1An9H
         8iCJwoc9g5ZSuSFhgVuLCKOuNu1VRO7yHsztxEqFL0gYJ+SaZlagyCtBiFXh2fw0S4xb
         3QyRM/Bu3+iZLDCHGinBQsPED9cUqwwVnM3o8srkZqPikDHfcafkuJA6sew3fW/6fR7y
         yFaanTOD9x8PitWMV7bfCn0Fli1dxEoXRIiBEzoeKCWgT4rHl8SNWeMnOmuWTCH6g5bu
         Qx7nqVmu24gF4/ltQW9AlMSkZGl7x7Yu2G5PKHkmk8BKbO9YDKuDW6LhX3h9sLm/7Zno
         IBgA==
X-Forwarded-Encrypted: i=1; AL+hErH63gIXM+JSZl6vanH5ElyXDsDQdy7w1Xpg7r/ZlFbJIjZdjDI2y5xNQZgBOi8SOowl4JnEXTGs3TeJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+76VPMt5oDY53dz97Bd4coXOuhbCBYklDsMZNGWUQcXs+NBVKP
	WWzIVCxaxLh67mgkiE9+M4nAXRwGZNz+z6jzUuHh4lrQ7SIdG86wmK/WmPLHoHgRPti+ZJnyuV/
	F0v+UOOA=
X-Gm-Gg: AZFdTZdh88Q2TGvob/BNcIhTNfYhLyUl620VFeoVF3VRVXw6CfhwvOk1YYKavrrus9r
	HxzKBeWfSvcRzMsHB3YighpqXhk7iWYKhtcQfJzveMnMOn3bfotmPexZwxKhNnxyd3RMhe83dTW
	rpqqsc4pwkGbKlMHIVqDDL81rX1wTzKQ22Sa2bKa395RCS52YohtU4yi+uLXpzjJ9aSuzcxsGtI
	Wx7TOXCAaajRiXuIVdL98hkPyJckxYhxqwk73RJnV2QfcjAtw1ja8ruev+BqaL/0RjJ4vYII3lX
	ocXhgGyq3w/cZ2Pvf6xB2sOkZUD4autRnrWgBD84HUhVMv3Ga+QyxPwT7nj2mazey9SVDTY5IYv
	zFJIYkD5Ueafsh4no9Eh9fiC+HO5EFKXJToGZC3ZEij2tB2EOV/dYSXriv11jkQZy18kaul1zTl
	d6y50EmTLUoYI5HCypH9Y8f8jX9YU62pvd5UlFtnJOBIjvhAxW2fN8nzNVQMN7pofqs/A0FMCTg
	wYkxxuTnR+KG+x8k6hkGoKnear88jDL7kw+LRQjbMfwk/n5IITqjH5XUn+6GpBuDwmislbY1aJi
	znQLV37vrRlUKdHma5rQ2m1l/DTTSp1fUaq6zmZbGRRE0uDYtrqgdRX8fT9k4VRN0H/tt+CV67B
	bZHvA/4jbddy8p3nzAsTOa6Wpmln6B0q3DeK5
X-Received: by 2002:a05:6a00:2987:b0:8b6:3e44:8aaf with SMTP id d2e1a72fcca58-8c87b4ee9c0mr2587050b3a.20.1795175070856;
        Fri, 20 Nov 2026 03:44:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm1443486b3a.36.2026.11.20.03.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:30 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: bfa: bound the RSCN event list by the received frame length
Date: Fri, 20 Nov 2026 20:44:26 +0900
Message-ID: <20261120114426.3072602-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
