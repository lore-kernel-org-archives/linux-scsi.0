Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186836;
	b=TjX8TPhpnIY4uZk/NIHLvIJshJRvCd/KYU8/xS1X6dHB9CSLtCHNzXheeIkTChSBX8fZ
	 o1e3z6z1EC3zvfssoWhrmn8X+uvfUooquO3V0Og4ZbZJ2gaZFI0vN5SZY6QKfI8Hcj08y
	 qvUFDMbZw6SdL2DggRbQwXZ2vDABDe7gJ5LbBDTHRNue7Bbya8O87Q32CVBBS5pYUkGoq
	 F+AXCXXyta1EEzKiKEuya4QxKeP7d8DvLFeJ3+TIXRsA9QZD2xvYBjGw0bN6LzbIHJTTD
	 MXqfE4SrPOvEEvZR4aMvPGktyUQA3Ca0iXOn1qUOFoVpe+qqUzz6Dmjbvbk7oaQfmmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186836;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kFY3ECIn4NExx9Mc/S3Mnyo0OuWA4JtAPvBIJ+oVIEk=;
	b=T+CcVct+7dZOzoSR31PrvamBvttMP+U749XMH9XMFBAdcBPg/vFyg6igBFD3pBGjFvtc
	 EI5e4ULoglUJeK8/uFzNgAzprt5LdkKkXO4fyGhPVAA9NcwTZozqoiHrwax/daMnE9GMf
	 HCTRwVKYyhVUVzHqkzktmqrP/Nyr5wVcbzioYX+lNNuPnmBVuYw0ICfs4BGRhuFEWycOK
	 vCK50H4rX86sMpANefAh26DFF6FgaO75BImB4GJ+xJmSBcHr9V/BIcGeTjy9OaKFJRD8Z
	 kq+YvMdZ/YiumW1sez67NW1zfYi1S5eSRxbjKyrMsGkWjDgCFbCpCITgJF7o5b8pxug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Tj8JOOBC;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6E606A32A
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BD6E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Tj8JOOBC
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8c6c06b3321so884664b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186836; x=1795791636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kFY3ECIn4NExx9Mc/S3Mnyo0OuWA4JtAPvBIJ+oVIEk=;
        b=Tj8JOOBCvBb8sah/JWRGnpnAD+4tf/NKyLWc+8PvCOExzuA/Bky1dIEmbFg2SZnZIA
         STVTKjOCRXtobuhQwSuM/6G+8shvwNhIeiRvaZrKppN6Jwui2xFd3FFjnMblNjOWqDfp
         uZuBdjn2/iif0AM4yL681IBHdQqpLIipdxTr+mW1kadqAAawgYKUIwshhGDr6GkwiDGX
         ti6jJxDMowc9bcOfWXx1umKo8wBuOuAnBZbh//Vc5TjbgebdKa/XrnNv8wnOEW42mqkK
         7V9K0MZeW4bkzLgqAMUQQJrjCaF81j83AWB1Ng/i5tHzEoAh2abwVwgg6tOxGMTHGzXg
         cr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186836; x=1795791636;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kFY3ECIn4NExx9Mc/S3Mnyo0OuWA4JtAPvBIJ+oVIEk=;
        b=W7/BoQByz7VqH4hm5xMYGIgzhPjC7Ra+ezb7164jWjK8ohFM/KNCXG2m1onjNrESjX
         Q8zDcCj/FZwddoKXlWzor1FRoBXjVXVdO5A8tUxs3nHXwE2/+fnu+o2XdyTt7qwfS6nb
         KZa/iRMe57eTAtqhYg+GwBkW56LBSk3TSgVuwqj59gYm2autY8QxaD24ppQSnC372GOB
         7YjbPdvS8ANKswKOSTkxdMJAfgK+tP7BWN8p5bGAMWFTEIQ9+ni+vX/dNjKwUsNHszSu
         3is+dtgrHz3rkEHeT0Y/EzYASvIesoq+sLV7loBRf+WalKyfOkI+yT/prwoKFwEoZP8+
         +CaQ==
X-Forwarded-Encrypted: i=1; AL+hErHhZiLOUoqZoswbSTE/OjQWDyqowyWZuBflyQbpJ/CmlB7ot4f4JlCAJ6GHe1oomAQKzO+FZhSvgTMK@vger.kernel.org
X-Gm-Message-State: APuU4Z+NJMY66bKe0Kv8K/3qCtJ2oIVlnc6qN/QEUBFtRqSUb0huNmQC
	8ZtywTrt0XVnCPuv/zD5mXuN5g1M9XhjMBH4cuGkUxgUUaF4Cul1I6j2520pOFogghk=
X-Gm-Gg: AZFdTZdfxEXvOwyIkeVdsv6XJxNDAR0SYOuRxya3DYstV+L2aiAZIRFWktam7iogrhj
	bJ9LGTuS/Bn9OSrd0xqNlBTERJoTgowehTTtTBvb8VVONczC7PvfbQbq7R8UeTbq1L0F/ZfgKzQ
	zLUjdZ5KEcSX200Z/Mh++iOa8HmbEdW6kEDkQmBUWj/kJyo82Cdvzl+TE2IXRcqgecBU50xffhh
	+Ku1GQM0o/qsMJ2av+onrzTvzyAg20EBl7ZeUIJ7j4mA1luJ8Lkr0c9tc+ACVMiBjdklHR88ala
	zGkFy01bObfglkSP87bN8JY/1QbLo7aZCwxEKOGRb3fhF2w28X7Z6Iq/tVnaT98McHBDndxVXsG
	WTiyf/ILTzrsdh9FsO59ESqtG/yO14VmHN9FYZ5tE2/Lo3LeyCrV2XjurI/Tm3try683EY64BRg
	IvL/0ClSR1ZfXfKj75xS+J/QP1ferW+dn3MgR8uRQ0a1rsy3Rur1VQXss37FHbUPDNL4x502muB
	eSzP+51H+v9PjIlnDPtWIfwmN9l4DBC43uFWFYuqtII7xa7h9jJhmFEPKi0yDQ4LGwD8Yjbm1p+
	kk9y+0MwM1SdEsqhg6KAYZeAKR71FLe3a+YTpvI2O15IV6wMpw5hEdysERz2u57IaDVd22HBEay
	kLc2+4fbLYanlmpJV4GzznOQ/a04/Zi8eD81Z
X-Received: by 2002:a05:6a00:4388:b0:8a0:1acb:677a with SMTP id d2e1a72fcca58-8c87d806cf8mr3356401b3a.57.1795186835627;
        Fri, 20 Nov 2026 07:00:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c272sm1670246b3a.19.2026.11.20.07.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] scsi: mvumi: bound the values the firmware supplies
Date: Sat, 21 Nov 2026 00:00:31 +0900
Message-ID: <20261120150031.3128191-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 15, 2026 at 09:57:10AM +0900, Yehyeong Lee wrote:
> This supersedes

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
