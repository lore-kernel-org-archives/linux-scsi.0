Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186831;
	b=umcASyjfLn/lOdqtghZSa24Ufnmvu68gcZRu0wIpD61UYMs9HgEwFL8DN5npXPU3/BGp
	 qZBESzhuiFrb1GVyq8MLLHupM7aSo/jLHI/mS3oKozp74gKfMXMg9rtYB18QBHmRz7A/N
	 JQyjxQlkb3enRJf1AxUtd02zdhUs/st2Lu2CW26ORx6qRkG7SqmU70hxxmgOnvyf6nStY
	 fTKdGy9JQWxqNTpuFs2UgNHMlRYFzzjRLL2fl3Jb2T1yZ1GRcXVlmcRYfW1GyI1Z7LjUB
	 HL8G61z9dUoLXJwTKeS6xbXC9q8GugTKaDdgwFnD+qoWpJJNergO8vgP6xWxyP425UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kg7NQpidoTuedvwQ4J1hfzPeomwwjR6JA06ZZj6FI/A=;
	b=hxbyYEQgOpocAsufXNya2GuHRqYz62GrrdwKGlNdPzM3mmFOFWrCsDCBgap4i4uQWg5f
	 4D/sRgFa7c6xQyvRuj8A0Lindeu6nhBZbiE6l9HmfwTLEms21WGos7UlYC3pQw6qXk8C7
	 nF3qysiuxNnzI+ax2SmgA8kaFWwKKAb7QKyoADy8OsnqxOOKL/rI5q15JlGVh/RQVbH6B
	 t6pHDXw8cEEoLCXeySYBDvDpra0soNj/JuXmGHk8XzFg8jXSEga9k4egm5Lo0NLJF6Wmf
	 jiqxjBc0CnE1feElwZ8Mb8UIExkxZVEHc9XAn8KnusSddp0rfAvR5K95UB+HMgc/FDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Lx4VfNRz;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25359606A804
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25359606A804
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Lx4VfNRz
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so624431b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186830; x=1795791630; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kg7NQpidoTuedvwQ4J1hfzPeomwwjR6JA06ZZj6FI/A=;
        b=Lx4VfNRzywUVvQC1HshGOmmIJ3yT9uPLWlhGQCEtBxYcKQnW7vUnavieMkZOclSzzH
         LrMtfPouH3p7sJGvXudbf4OCe1WrNpqM6Ox7xUWgUoxQRAyGmeenVY+XcDl/8Sx6JU6+
         Ur9lboTFER8/6uDaIkgSkyZ4ve0ZVqg7NeBmCGB0lgHlVx30h3X+meqy14wtKXJ1lZsz
         +fPYgl81CMPdQPi9S+md6IfrPS1E3gY2ToUfkMNbsUt+nE8htWgEg+xF9bFTMICuGmnh
         votFLb4Sh9/r1PLhg0TeC8wFrVe0vK6hHxrQtweCMrE7R1ARrsGMu2Vkd8U4ZcqYWXdM
         7ZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186830; x=1795791630;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kg7NQpidoTuedvwQ4J1hfzPeomwwjR6JA06ZZj6FI/A=;
        b=u5jF6d7JNDBSnA0oUH33tZYPXBcIAEjF9s2sUuyUXu1H3c5fSmY9TOTYxqbbW3ZW5F
         E3t6SyDzUMR/pWoG+iAA0NsuBN5dwBYg6Kp0rMnPtlXDm85T8QJHVDRnI+zP4ZCmbhFi
         /SaBYUEIpEsVoyl00tv6xbU9nLyYTf9v5G+qkkia1ljivh8yRmOF+1izor4hDg/qf7A8
         We5H/VkhjVHDusDjCMXAgxSYZB+riaHuqjFvoob3uxCkIu5ZBnSxEkh+kjaujwZiI2sf
         +BOL23vWksBpOwBV/UXtc9cJl1tIq0rK/hkWJdNhy+nWuWnwXRE6PxcjjCYniLlnFaQm
         ySJQ==
X-Forwarded-Encrypted: i=1; AL+hErF8Y6KI4sgChCRyvuTeieuwwXESO/FfiJkt5l86JNvsIjYYmBV1Alc5nK9xD2L9zflLkcpMqdsxaVNo@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZlIOeDFleXaaBrvLgU69Hbw9r+sHgVHMTlayWxSCDSNPOOm4u
	EfgL3k4OHFUN+I1HgH3XAxW0X8PPcPToDnCBm4UUcHIXW/IZvRiq22c5T85QXASab50=
X-Gm-Gg: AZFdTZfrlZyZp77wdxesa8SIfg5MTr2XAQN8+5jmN/mt13dqWUiRijWuWPQ96chFg9b
	fUCyZVgb5jmEjJKG5cFsuxyHPufE3xB8p5U8lvJOgXQZZ6+SFJ3Q49RJiGyzyIp65ljjZK/fxN1
	LKD1ZUbI4yK5f5K+dPaZFW7YXjh47uFFaX8MY41fC1cyAteRhDYK6a6uHe4/bo9K7mvGh4pb9Pv
	hehKW4arTe1xzVnDilNBK/2M6YXmggehE1ZlnR3bOF+kevdljgMShEgfJUPsKAO1o3sGwMj0Ebv
	eHNxqPkoJa3aYjIjOVWb+AiZBh4S44sW3pYhMgWRD56Zy3M6tg7ityuzQwos1lwHd9Pbsnf3C6J
	4l0ohteFizk7tymGs7XOkhdnSuA1mi0lSG2Hiab1VjRhv+PHn9Pb+ZcOBCyiPpaSQ2qoVg4WU3x
	86sLN83JO5IONecFa9IjcGvlKewaEoRICAtFp/9P1Ddv8LdNKItdPBX2fUuCFy/sA8dhK3s5D/V
	kuN6T4iiX5VR2q8CZRMr8jIJAXHOjdS//tH+xvnkh3sWwbpxySwJ1BlZy9BFgW6YMTAT3BNqq1T
	cdrEfgc4+Jiu5/HhcN4wf1rCBauIekx1WJPkvwmhcyhP718nOtSx6+oY9JHXEu6SB08MW1Mwc6H
	fhDLPrV8vx7/fYQz1RxmhFfI13/G10XWYbaIy
X-Received: by 2002:a05:6a00:27a7:b0:89f:52ae:612e with SMTP id d2e1a72fcca58-8c87d516fc7mr1969039b3a.25.1795186830605;
        Fri, 20 Nov 2026 07:00:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077bc47sm1697153b3a.6.2026.11.20.07.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:29 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] scsi: mvumi: bound the values the firmware supplies
Date: Sat, 21 Nov 2026 00:00:24 +0900
Message-ID: <20261120150025.3128175-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
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

On Thu, Oct 15, 2026 at 01:24:08AM +0900, Yehyeong Lee wrote:
> This supersedes

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
