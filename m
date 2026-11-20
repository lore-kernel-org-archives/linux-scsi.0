Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186788;
	b=mPoAJN6AaCjzfbf8+tAqjD3VKSrVaT78q+XgK2CMEfC5wcCtrLvWoO1JGVjbEEYEa49s
	 tKEBL0Nbjt5g/6kRpE7bfNCts0Y7bmqCRP+JDAC9aVWjrhEyWjCO7eqLTYf9tpq0v6+j4
	 rahFAWsMqAAMzweXM8HKy5WvHk1Adt/SUdsEdgo1J7Trl5H8iDiEZLZHQvotvtfc/fGyS
	 by8c/kH7PemiUIbz+7O3TCeV6jW8R1z/hZM3FxwNzMnEmj25/yNkZN97nt6biqPGSy78y
	 zjciFJKNQHqD36Ssk/CXmNhPiArtPXw4xbDgjU8pT55O4cnRHQJ5/8yw7ku6YD3FDKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
	b=mbApWVnA6lKGM/vlH1PUli/4gnYE0SqBPtftA9Q7TGf0qqf7nSnC8exMNXRk8TnsuzBI
	 6EATxkTemdOGKKIJ4ztxTae2L1sYTh46DxCOccrCxJASNVrrBgcy4OKl7+SJHWWiaRvve
	 tyDXbyCctHcffsioKPNjo2fasWC11HL2YZwSVvrjFlLiF9XmLgnjBiq5fKmteZIIM6/o/
	 HoiPpF2dEImxHR+R5LSjbSO6bWHpvANshT0MxPje5WYnYqjq9Q7tLHrQEM9jtrbBNBymJ
	 wqy0f8peO4juagkOvAzMFuYj1TF0qqsvPxyjUhC9xY0q/5lyTiMTwWoNOMUht9uqTMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GQOBYiiS;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD446074D33
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFD446074D33
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GQOBYiiS
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b41e627cadso590749a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186787; x=1795791587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
        b=GQOBYiiSfODVUY5BPry3vYjPqZmWwB2BfZdrAloTbnofeo1ihjK8fEuQmY4qAki/+H
         jwPOg8fmGgNKjzaulexXfpXOcrl9MwTULPR/FJxdXVJsigwLWaLXAlxE6jqrSNMGc/eh
         j52M0zK2n6Zpm+MyLwPg0s21NdU5uwqmchktt2llqHaQayd9LVWN456DCblY1+3JY4HL
         XhndWn9Vu+h7ht+ze2TgSV0C2XS5wgVL/G97xEOt4LpCp/yhAsLRsl3TNgrTRAPYXgGa
         SUhJX0IBxJll4EgXwcY+Sd9f3UTkAqLIysWbU6QJnSXhRakTLmSwW/CvoaXZxntnu9Gt
         sYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186787; x=1795791587;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
        b=qTFZ7l7nAyyfg2VaD74kXCf8VrIqT6I7/LOb1mzw1zqbdjdGwp9I9oQ+JnmLG8phSi
         LCkkmvI9ula8XON7JY+taskEBKt2ELB5fr/vu+XBTKgEnC8URC1g9r1n/oeWLwmcN3Zy
         pW32MmsMdYxxmPR3Rte4mKH7QscIeT3ulnneVMKwzDEhFGRMBZ2yuYz16Du6xxlYv5op
         RzoRNmmGnOwa0Y5gO3u5H/vIh7wRKsCAFem01DTK8mMZ5e9JP7MNiN+J4WLHUUNt1O4p
         iVJ2hST5G2J5XTklPeyVkF9FcFex2qCxokLgH7aq8zh5m/Z05z62TKO6vwAl6GMgph+R
         ty7w==
X-Forwarded-Encrypted: i=1; AL+hErFQ+vlvJ2VlNxDtzJA25xxQDzUzuGxBKdjZ1zJEG8qWPPsM8Zz2HzpDZlWehop8wQsI/VPhBDpYHypq@vger.kernel.org
X-Gm-Message-State: APuU4Z+t8Up8Y6Ia9piihsUOUI97xO9qOjGcL5JjABHKzNm6JF8MTF7U
	Vleg4oaEaS/NVjrGGOwaSE/kY9nw9TgKhceOgTe/pzST9ua4boKd1YSrLfxNRvGprps=
X-Gm-Gg: AZFdTZdeyzDc7e3MhYVlX2+Jjkv5f884CDdjPrju5pGIDjeNipRDe23Fw09j0JWvJ2o
	hVHqUEknRJXGA9hugJzVxlaVZ2/lobo4tSmx47S2MiLm6YUt5MRA+yHq+E9AGQ/AasYbsUzFHiY
	3SrsiMjXz2wLDIrIH3CuZcBHF4+f0KE7Pn76KVnP9Qn/BdjW4gbk4JsfWR7XZh+V3Xz+IeX8+Vz
	1jpvfGifB042rog1HKp9VzqLjCsGh6NFI/ydB0IYpIQGaNsCpHoZitGIFuS09xUd7pZxWvobHKt
	vY9/hMQCR9rDa+FOxvDRK0LjbkpqagB3/6HBIKQUPRcZN82cflk5U5IB5uGTdEEj1LK0OtABZNB
	YahUuulMgx+PKRG51ddFQaQ0j/GTdI7kW3QGOBjrs3nfRgS11ShH1DHKvPP3nI5vCswxeOHhqAJ
	wJmeLGV+4vWaWZ0iYO6UxvTRgkGEhApsophMqgoVzD2oJVpjBS0DCoOc8G6tuzbegAOJmApOyp6
	69x2I8R4LZCpkm1JtsiJyKukADdC8s2CP5n9Qml8RBa90AIV8XODwQSmHEEwUHnr+VpQNjGDJmx
	C5H17Eb45XonEjkqcIBosItLjsvDwVLLYVSuBQewih8q3nnqSnylilnIRulTKj+vbAPOB+t2IF3
	wVKLTs3Wclx2AQFiYR8nvcEGA1HI+u2yxTxJm
X-Received: by 2002:a17:90a:e7d0:b0:3b4:a90:7f3b with SMTP id 98e67ed59e1d1-3b41c97c98amr3317137a91.56.1795186787223;
        Fri, 20 Nov 2026 06:59:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm4660624a91.0.2026.11.20.06.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hare@suse.de,
	bvanassche@acm.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Fri, 20 Nov 2026 23:59:41 +0900
Message-ID: <20261120145941.3127955-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
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

On Mon, Oct 12, 2026 at 10:51:59PM +0900, Yehyeong Lee wrote:
> ft_recv_write_data() executes a WRITE once the received byte count reaches
> se_cmd->data_length.  Frames are placed by their FCP relative offset but
> nothing tracks which offsets were filled, so an initiator that sends two
> frames at the same offset reaches data_length with part of the buffer never
> written: two 4096-byte frames at offset 0 of an 8192-byte write get the
> count to 8192 and leave the second half untouched.

This is superseded by v2:
  https://lore.kernel.org/all/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
