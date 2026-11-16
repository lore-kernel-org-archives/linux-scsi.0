Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824051;
	b=QjeXtbjt6Ul71LbBxEvFLynJn6A/dunjWbWY7+9Xc+n8K+6tI8gSVa1iSCISCnLoi4lN
	 fw+S0/tK3fwhlg4xei9q8PUfCs1aPSh1S2sEKLqI10wwWIi3zi5aot9P98Q4fpCae+Kjw
	 o3KYXgr1p5sa3MnP7DZaxVnqoeUnxTkXbz8zgsIcwA0umQSQGTDcXwqQvIHcl/px2/Iy6
	 ets6kVDzJdvdRwmDFchuJLkQmM9zoIVPcFNYB0nn41w0o06QLk5DVYBNedl2xQm+w2wmi
	 rXXLkGUwhIVAcWYsdu415gq44GRxKNyZE08oimoV7hBlR//cAGi1cJn5M3t+Jw3aTEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
	b=m3hLba/xWJof8ygqxRWkXdgGvMhwNrVUUB3RXf4Z/ZkF5ilRK66NgT8k0IMfkZaCUB8o
	 o5DNSuNqhBNi8zGu0IEo7jpZ17jrc6okuYHJI5nFiRCqjHHoUr5JgBsVRPskcCOTFicj2
	 np/5a9NIu7+kWWPg/8O+uAjlq9HOTE3twhTGHpu+jn0jgePbq1eWeZ5DkIjaHhCmNG7sN
	 J56pDqtlW9OlGKG6D++5iK/FEZmPdJarOzLF57/0CcWOJ2DeTQsItntweJq/oPMd9/wbi
	 kClWOL5UPX7Zd5Af8bb9wpS1kN1bZoeD1iGriIOMqHT83ZMTq+TugESXwjCNKXJvBTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LJdVJliv;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8E5606A329
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 10:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D8E5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LJdVJliv
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-37600b0db49so3792518eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 02:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794824050; x=1795428850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
        b=LJdVJlivULwySoKe7RmHEPKDa8I//vM/iWsIU1h+DLgudWNXKVV6sia44lgJLI5Xi0
         wr1smIU1P9IioTjZ/neNVSRzaOfBGTfbum+dpcki4uxCmk/vSaGzR34Aq182E36yqBWJ
         nKBRncsEQKyLiXrZ6+h82rzFtqlISgOBZrHfRdNYFY/c+LamP7WiibdKv9KQYNYYl0dk
         I+bD+lNU9tHNm02lHpyK6x2f+unB8B2Vi9dcMTpKgSpz64iMNtFGOIJraXiF1/nXCHI/
         eRBD4f7OHF9uaMa7wkOWWmvvk+v+EVuYFtKMQd+y+yPnkTHgCvhQjKmj1gLoOvEP9XzC
         Cp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794824050; x=1795428850;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
        b=WjYDUFOxXL5knnw0SNYAVJ3UrcM4a4d/jUE28owx9QVxhsHF7HMNOmAVC2wUZVcbIv
         goJ82rEyMuXLI8tEkCS9yZj61zPcXbc+FDKS/lHX2kLELRaUD3mWWhNbRNUrCB6bmy5y
         Svm0HvqTnPGndt/lTdCLTE+/tKYXumz6WukNK5D7aNkJXLNJSE78/3cW6jGEtfpoNXH4
         cscrhKUjmqCJ5UDIp/LO3NArUusEn4CgGP/+eE+ZddnkVhg52jskSE4v8c852Yyab9/u
         VN/UbuVNJD+YVqfyznri9UVnr5pTiD3lAUAvO4RWTz6GsYkIW97k6I3JuAqCDg8RbZNj
         l+5w==
X-Forwarded-Encrypted: i=1; AL+hErGz9D/2txWTGTKjZXdIpD7ROlnfZ6OKFiblb5MHIxtwJ6LCxTTvPeKHOivWySpHbof+N9++3nUfZJGV@vger.kernel.org
X-Gm-Message-State: APuU4Z+4Klu+UTgxxv4KGXVGry8PSvFgdc/DfB0fG6DXaTb3ClrYdLSG
	OtK1kKuQiO1ileRWiebeIW9XivtTCrLb/pGxxV2guNd8Evob3D/y5fhvE5HKkQtMmk0=
X-Gm-Gg: AZFdTZcOkKaeGaQlKwTFx9pYNZ4x3Je0siPBMWcRZAZPSvWEjdKLBIDpj+7wqT099cz
	/VKVRbEl5fjJdqykUWVdJ87QwDjk1vsas9MgjZ9U3I8u7jqL18rSr5hPbHVl4mLSxF6U9pMorHU
	5NSwFEks/Ywi/PoL0653jMfrlsqYytthkUSvR691rWOjOlR4cQeyoPN/mshfvryfAaYZO2R+QkW
	JXnyonKQqjzUsLgTlLYMLOveODeBwRQpj3h/LvLhPz++RlByLO5yx8WpCvN4x1+ByqUlCZTMd5j
	0BpsXakqD14AVE68FiUq0z2L2VyjHzbjGNGJW90XV6lETUmNzPf3vWCbwSIO2GHAj8nFFnRjrYf
	UbxNiiErbJ5rFomVA1Bn+FrCUcy6G4TMOvhHR+QOK9ljqM2HOKiEKNr2JqI/JQyljcvNYX9+TKA
	Yx5OfC49p0kYm2oWf3YX22Lkhm9Xit3xN8HtD16HZfwzNHfWDbJXU6MNWgrbI/sKLulp/IrE3Qz
	CGXTVYrRrshTFNhMCjL/sPtkEYkAYRo72/3nyI030E4qJcFtpvLMjhvYCvsjdhht6AmbYQLcb42
	oBGPg87UzPDUL/Skc0SpLR8c3diy4VBw2U2N61AVeedSHCxbfSzhncEzA9df2q3FvRqtZ57FWl2
	nORrdcgm1oSxurxjPBZoIgkXN6e6yllwd+08aGQ==
X-Received: by 2002:a05:7301:f03:b0:373:64ef:5dfe with SMTP id 5a478bee46e88-37966096b9cmr10223982eec.8.1794824050090;
        Mon, 16 Nov 2026 02:14:10 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm35126665eec.28.2026.11.16.02.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:14:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org
Cc: mkp@kernel.org,
	michael.christie@oracle.com,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: do not reject the command on a Data-Out overflow
Date: Mon, 16 Nov 2026 19:13:48 +0900
Message-ID: <20261116101348.1650677-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-214783@kernel.org>
References: <20261114161931.941441-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-214783@kernel.org>
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

Thanks - the NULL dereference is real, but it is older than this patch and
does not depend on it.

iscsit_check_dataout_hdr() already answers a Data-Out whose
DataSegmentLength exceeds conn_ops->MaxXmitDataSegmentLength with
iscsit_add_reject() (iscsi_target.c:1573-1578), before it looks the ITT up at
:1580.  isert_handle_iscsi_dataout() calls that function, so one Data-Out PDU
after login reaches isert_put_reject() with a command the core allocated, and
isert_post_recv() faults on the NULL rx_desc at ib_isert.c:761.  I reproduced
it on unpatched mainline, 5 boots out of 5, with no SCSI command involved and
this patch not applied.

It dates from 4366b19ca5eb ("iser-target: Change the recv buffers posting
logic", v4.3), which gave isert_post_recv() a descriptor argument and made
isert_post_response() pass isert_cmd->rx_desc.

So I have left this patch as it is and fixed isert separately:

  https://lore.kernel.org/all/20261116101108.1650132-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
