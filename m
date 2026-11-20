Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175082;
	b=F6An5d0dixsF3tyQlDJuINAo/9Zd9Cr7tb9Zg84xYBC2UQilYIa+dFFM2Y/t/yY/amxD
	 fZQ/f68p8RBfXHqru8uc8Ck8PFFXjw4gVppEDC1uab3yQqiLvd4H/j3KHvNYADJx+BgOK
	 7UR+VKj8/BHBNaoEe/I5exL/ZJO+PNAjBGiSOq0Fxdggpn3biVUaaYFJ7hhbCEhUDo9T7
	 sRVR6P7R2sEsB7/7h8vCJGqzs7Oc5QGHhG50MwUmcwkdFTGZ4hId3Y74NxS+fXBuMnQma
	 WxfKmVyCluMwdjarqMiY5iAsdCaeQtCXyO84xptHXqkN08ojVtgMnPX7mOAL73lY5wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
	b=DXjTTDeU7Wyx6PNIp3kIrYNaXqvIlGTDPPQMoOvD83fUlbjyWOjpDL6WyWbWDEoUWhq4
	 x28CebYCtsIpqhEKOq3AdTa4oxJSuGf9tqP4ibUrS4OCj8wjpCRz9jFJm0LrJXu7a2wHp
	 QI2PIzH+P49bRkLSnhBkClJNsoe5mE1VvW0eFgkRznVcef4W6I5Qaq7WjWNkHlzn46HMH
	 OOiAoZqvzd10bDrvrUaW046I5zbsVV7sse/qGAVxkRpyjNq4fDcqKRSGOsh+B/Axapjo/
	 ETaw+KrrClzm29tAwMsJfownM605xDBn9vy0Out5BChqfVe4i6Zwb2QhQ34wID092dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cnw6IEIq;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E7E60A380E
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69E7E60A380E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cnw6IEIq
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3a914e4c8so480989a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175082; x=1795779882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=Cnw6IEIq/AktYRV2USksXF7EAwqu0FAGMqTsHjbh4ISE1J/9hGAPLV56F74IWpLNbS
         tc0icoflWo4ZppuV3leeV6Vmabym3n8vhUqcuTasw+E7ZrmYBL0rMjQ9r5+3/LekQ90d
         lDCcjyl8Ta0wrp2/3kM36f8TGrXquEc0Jt9ib2wUGONOQtPswHErvnTwHbStAgMqtNLP
         4D4P0ie1E9C8uLUUTfzzT+7sN4Dpl1E0H+AlCNc3myHGkEK1S9f2UwkOtJOSPlSnmh6M
         Z2pMxzn3vMbwh9TqFwZULQILM4xbGjinH62CLMbG9w4AtqzekZKDCZUczIl6h/H+HrIC
         1mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175082; x=1795779882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=xJ7UDHdJ5DBSWnb2LaqBfk72sxo0oX5pFT35alD8v/xsuK21c0w1h8V7dqg3XOFmqD
         rr3NzXpmuqhu/+mDcvDgRoVy+s7YRe+l9ihz+2VbMLfQ3xmoxzAds6HzuBqnfnkttStZ
         EVGlLRfADjtQpymYZg2Um7hhuoHwNz1YH1h3io0gnEHMZN9q4lJu7gCZ+IKEJ/B2uC/V
         vcvHZmFOTHIKzQN3H7DSSC14vtVYkVyy/lsuLbCuy4UI2hi+S8APDXfqgZBGBUeOrXZs
         GHD2xhhSm49lVTV7/9bcb1pQavjpCLpu9Zm0nl3nq7w+tmPShrtGG1OWX9jMiwBeAf1W
         KAPg==
X-Forwarded-Encrypted: i=1; AL+hErGbYWe7mJUV1hV4CocKc3Ec0u8fzbl372k2FEqp2wqs6LoFyd0gcmxpFvkMOjyJTdHX+xcRzd0VPKDw@vger.kernel.org
X-Gm-Message-State: APuU4Z/qX/xT0wpK5IyyEoCrxheY7hneeVNOg6WHh8bUHIQXZjqWNrs+
	l0iiRGiu/s4fh2DVYe9aVNIwJ+fIrD2w30Wf3iYhFGWwuaK02kxPj0k63Rr3tM4YxcQ=
X-Gm-Gg: AZFdTZdihp5AKVLT5KSt+NBsljeMmwpw+Jfh5jYBKgaaxvi5GvrsXGWPwyk2rwME77m
	KUJOa5tBVMbU5weczJaceuEMUTIerES18eZ7UV8WpnNbkAIUspfy79AyaE4kinlqXA4F/inPrMt
	r0jKDqQ5PowJahphq3adj/fTK7iKmNG4TfiZTisG7En2x7t8uWDd8RaZOZk9ISzwquzwvABOXWg
	7NvSWjlfmx+vKPWOSf3jKAPTZxP2onk89YkIR6J1qv1OSRuNdG/zV5YcVwSb0rqvjbHTELBcPqy
	FGBQNPJe5gmyHZNIKOW2U8ewJFRtcJCYqMuNahG3GXk8T8Gx83Lm61Brh2EwS7iHDW82tekROd4
	Qz613EmvIdlGfVh+x38auRu59OM7cMjt34RG4z2qgqc1vWVPUKG4MMNRj0bq6yUqyDBL/0SAr99
	07CuW6u4Z77Ssw3zrYeER1SV29gS/p6eT2OdJLJ/BZY68U4So5CxnpaukNnIjSogQeaUgJeP542
	EDIFIuFA7jznClDIYgi7Nn3dVh7cYDMIBaM4SaiD498JVw+e87ddDdyKcS4M8fhOtPbuPO1U1dd
	HjK0QmPapI3LTmbm8vcbi/FQ7x+HT9OgfnUJ2EbI2+CmkwpnBVaB4V8vRAi5iJxrigaf0cH0x75
	8q/0oTLUbZ+TGpCjvgyVIQKCvgr01Ez9qle3k
X-Received: by 2002:a17:90b:388c:b0:3b4:1877:8d35 with SMTP id 98e67ed59e1d1-3b41c975320mr2681077a91.52.1795175081857;
        Fri, 20 Nov 2026 03:44:41 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm4339969a91.1.2026.11.20.03.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:41 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Fri, 20 Nov 2026 20:44:36 +0900
Message-ID: <20261120114436.3072633-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
