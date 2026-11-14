Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794629849;
	b=1eO9ndEf3YVG9aDxks8XBHEmr3qdasfjGoXKUQBqH6e9JbL7xPQ3P55lKo9mKfzUbMKn
	 Cu9FW8sixfUy2ao/yyVfY9iLvofndmmeSJVZBWADqQU63uXhDP1snUzFbE5TVeequMGvY
	 5SkEVsMmdufT//Sske4QIKAlvDU1NP9M+VMdeDFbwC5+COBSVY++jNT6JvT6x7IW0HWys
	 ZjNqi7Cd7CuCDq37RU2OAWGZTyHrFtebC4ZFpqPzoSpl+468x1KAAc+zbxz9qh6yBdKS/
	 CepJX2lz1WUVycSDNXX4gfPOnMjccUidDC2y5jaOQXzJzYD5toPa8+GCU44jOc6pEXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=iB/K03lI4KCa3CigydQl65EWnXtxB4ckz0UoZC12GJM=;
	b=xiHnYn0txFPRLeWCE1mBgwmQACPjZ1o/Erfs+zplUL2viyCHAM8ID4o66mvDMlqM4tGy
	 JGEKx4dOOMaCqbNxm2+ZON7FdZhkdfpqbS+5lvqv8xEKpWa0rWDaBzy6QF36J0Q54qxIm
	 xPNff/p+EbU3pJUntrxrFDpov4mrkIOfO3UpsnfNV3R4dLIzjlukSqf6pTNJQs+PhjVFP
	 6m2u4aVn3js5O+XRPNQ6fh8wrclCB+5D7EQkAuBH18c+FltBEmfyNnGhvkQ9s2bbR14MD
	 HSdjpxZfKyjzcZvZaO0GVdJ+0aKTiFkJjwEWZaVJtwEHV4GSK+qxcqKHScMnWUuIfDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OuFlSZ8M;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FD606A329
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 04:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 136FD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OuFlSZ8M
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-170135e43c7so2248860c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 20:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794629848; x=1795234648; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iB/K03lI4KCa3CigydQl65EWnXtxB4ckz0UoZC12GJM=;
        b=OuFlSZ8MQIsrwDi8G4zjq3k4pLwpvbrHSKiXX6UOXn/y5OvcQVTwJ5FB83JYBW2ON1
         HPYLr1mbypw2ko+jPnccdjGAf9K+pz+0Em9zot5d6svD+mog6lio2H3/cJe5orVXUSyB
         wOAAyqfk/v/JdxSytCjnZSG/Dfmdw7i7anf/3UN20SwqZrlRlUy5b6c9j8WYu+i5Tyzv
         sxSERoMfahWESVOmlN45nFSnvZERoZJOu0zlqHsO1jfKreKbjRILtHbVTQsZYZlx7CMe
         M2IXtNcjwRP4mlcG+oT/rujgGAG7Z6CLWCwgFSDEBAfcdRGl9MP+Eu+eTgLc1dWUPmyS
         zPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794629848; x=1795234648;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iB/K03lI4KCa3CigydQl65EWnXtxB4ckz0UoZC12GJM=;
        b=IFHvi4U7Pi70n5rDGoSesedIPJfR/VTzs9eSo+THL92+IFCH7Qn+MGfTsmW2YJJGm8
         3SyqrUU+HBXlr8OvYWHHhNCUG58GI9KTBwWjGaxMe3Bzaf9oMRtA/TKVV1d3/lbvL3Pz
         IYLrZ09kpJrMRCG13WnDwHfgk5l0BBHKMmsFUys3tl2t0icwfJ+i2yaoF3mLJgFcUIjH
         WxhuASOUeJtHgsrS/LRy+jjJcDGWe/g/iLxadUDmoUqqytsYEVntYQOVoOk4qtLJsxnb
         0T32ruvrnk7k2sdtdoIQC3dxLxHO4sgQqDQBUCIYylUIH+x6wQUx7UV3OL+FwlCvEhSA
         lKew==
X-Gm-Message-State: APuU4Z+ZxH3PqBuiHYRdGchLuo350Uu7iZFJlzF+yddP+gzMePBOyJnA
	IHxiC6ajSw9T9goozziJigFIvECaLDQZcpqS2j8qVUsA2A3evXMdqQfLTWSzBCZuLUypODP0si5
	5eYDwBzB/Nw==
X-Gm-Gg: AYBFou3w1b14XA/cYS1/EsBq815GZY1vtsNQUxxK4C4oNtnVm88WOeTl+cwMXAwJCaz
	9479sOz+TYab2LE/zjH06WdEbcYIq21Y7UhT2ppYDs86a06ZGWvzjez6xbD0pdNVo2yb2KOqzt7
	qK4gB4y3HW3YQVZTRPsrOtov3Ur7wK/HgLjzZuJHulB0QPYuSz6jwOBu+tB909naUjoR/nJEWFn
	QZvRnzbDFVV/ANyV+uiYm86EL+ArCNmgKXlZJToD0DjuncsUZFtHIfZujk+fNEvXndIvXmaMyHj
	Wz+R8QYPjMgnvtqrSi8VyZrtipCRTIIStJjAdk7LrvAyCipXT4ya/Nrk2tdEmvG74/CjKSZDMEe
	hwjlQlR9ePlxAOC5Ix2oW6fqehlSR+OcD1dhP1g1gyPDSDzTYP8wokeY7B0YfdLDAyVdEQ0iIdR
	Kd/wzcLardtpcOWpWOE7Wjsb2veQP3yq9gsTwHv/5V9Rcy1Q1GRy10rktoGwPseN5UaXC0MFpxS
	erWKqaDtiTtvLQDY3fzlWyI096RhJL47XWmnWuc6Ia6qrKam1oreCB1ubB7PPlX27kR1axVqrWn
	U0WYKL4BKLvjXboqyhOiphsTacF4U+8IsRs+ckP8Fbz+ghybiAl/YwxzlXrUt46R9XHnNjZXGzL
	Ltmuwq39P3JGBZKty3U39iGnt152bESzp60rsvQ==
X-Received: by 2002:a05:7022:2390:b0:18d:96e8:b913 with SMTP id a92af1059eb24-1b503195191mr6210044c88.47.1794629848063;
        Fri, 13 Nov 2026 20:17:28 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b27dsm11046075c88.2.2026.11.13.20.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 20:17:27 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	ching2048@areca.com.tw
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	erich@areca.com.tw,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4 3/4] scsi: arcmsr: wrap the type B completion index
Date: Sat, 14 Nov 2026 13:17:18 +0900
Message-ID: <20261114041718.551698-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-214130@kernel.org>
References: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr> <20261114033810.549787-4-yhlee@isslab.korea.ac.kr> <sashiko-outbox-214130@kernel.org>
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

The review above is right about the Fixes tag on this patch.
1c57e86d75cf has no type B code at all; struct MessageUnit_B and both
doneq_index readers arrived with 1a4f550a09f8, so the tag should be:

Fixes: 1a4f550a09f8 ("[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other fixes")

Nothing else changes.  I can send a v5 with only that line corrected
right away, but I did not want to put another version in front of you
just for a tag.  Martin, would you prefer a v5, or could you fix the tag
up when applying?

Best regards,
Yehyeong Lee
