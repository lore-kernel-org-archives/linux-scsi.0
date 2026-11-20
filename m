Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175029;
	b=c5v8QHYvrTDHlAqwkxtXDDw5BPklnQcKQc2+nHz6YDwrXE11guTeO164LaCYyfmHe+hg
	 9GkV8jKZu6gKzQFq+xA78+jnpXhoDO8TwCpE0nmzPmeY4v7ROadD58ncTMXYJv9S9RRvE
	 /0SWt5eNbEYMLVjihHBC3y7JiToSBsp6jYLFGeN2B/463fgdyyog61DPJYzW6mDjjg3My
	 S5LlLdQU//6yuquK5hqoLFvXE6wNjYa4zGX02FULZUV5l+Ctr+sy55bLlAPRJPHZl6bsI
	 YRwTOxGK5s4Dzt6vyMiVAjRTV2o0eYhNLOtrF1y+3oioKbLkaVpb7M4c3eFZeGNGXKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175029;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=XjDfiKu3I75ybdcF056Ds7jHUZyRJ1qRRCWB+Lk0ztKvb7Wq4YzB5BVNTu/IRIB1TEWz
	 1qX9nmQJsI7o4H89dxAH78ncwmH+jJfONesGyEVIiYIwUmNvy84aPZqBawr5YrZ4wSfd5
	 ZicSuxyEv6FNSPAp/WGxFoDHR1rbVg/38dJc2JGtfYaebOWt2tKa9Q2DPDupxx5h+C9/0
	 NyoKEPKtiGOg/+MyEic1WMlgfIxw2sY5bAB6mUvkhbrHpRHRkezMsrWayl7lQDopjkX91
	 q8QIMqnWt2dRvv5I75A9gKfShMZ4LubxgfkKe9EY/ZE/IhRFfk5RGcM8Zi62D+i7+3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NhGzSQH1;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1160A3827
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D1160A3827
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NhGzSQH1
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2efd659464aso2668645ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175029; x=1795779829; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=NhGzSQH17nlkip71WNTcEZpTyjedR8LT3OnINR8pSSeE+WblknToxWy7eEPd1aF7Is
         JJieRX2de+cMdswykyCZhJMxE3Xj77YPpAB5+AnT8jc17E/HFb3m/xwNBSFxdIL7q97B
         4exlPXoZK5qpAYSB2TogNlqyNQPiLxqn+DseLSI+KyPQljFY+ADTUtq4phVs6lOZBc3J
         PD7PbDCjC8lHlch9xm6WO8Rpi87a8J63ZiTtnvU/xwHt7Hhk28kEkkRlAmow0hBXjGWH
         07ybTGkNfBt4AHhUyGlY9kVnXHZ9n1BS2ElZH9kVeOpuhYkenpva8yxHF5Jw9QFtR3vA
         C80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175029; x=1795779829;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=CBM7H1CRaE+n/FSe+jI/rC7DRUUOPg7pee4Hx7mvFSFx21N0Nefh20fJg3K7sYU0jF
         4yokQL2IWyRAn6GsrUro0ZmIILTvqY9Pmzi046Altt2dFXJC9+wOsVmK8XvxQU/mNuuM
         iTrWln4P9lUOjkQqpmR68Qo5TD2/Yq2ya3/btuWwUXlEB8/J4rGu6NPxJFv23D6HPKh0
         /Ph8MyrlyL0IEm6u/Ou2ncKl7Q+cEIFdxO2vah091zb8FOcbfAXvKkTlnmYoQ3RlgmdN
         07vDD936aHl9nuzNS7937lrSXtcwoqgjju+uA4aNWY/EJZHY+vrLIhOH3v6V4y2Tcv4q
         958w==
X-Forwarded-Encrypted: i=1; AL+hErEqfyiMXAkaAGkCjvcsdMe5A7xI57d3wakpB0tCuARpTyjH4Ayse4HtYlnL9WekKaNvvBPaeO9GmRAc@vger.kernel.org
X-Gm-Message-State: APuU4Z/okp1jxnKRM+0OpOeUVUQWAyPm41jSP1sKO5Nvh0ga07WFnWQY
	m/AcE0iA21BvGeJuU8ffqovSU2XkTFpbnlsosfQr6wpOfZuHSTLy4zUXjCpts1QPWMC1gD7T/4d
	wx/lw
X-Gm-Gg: AZFdTZfr2CniU30VXawvSaodHVi4jmch+l6iUUwjBtPg2hYlCWANNjU2OEyrN4knx62
	A4fMYojFVgN9ZZlQXHYv5enqb+4tDfMN3o6v0WVVims4ku5UzY8Dx7G6ReVPe27ZyJHVfKGeWgT
	MY/9/LQMaNehsMkV+IdtGgGr7/I+JsUWbm5VFF4jgdtJtHwtkllRUMtFsEzaNHRTXZ6VIXHH24t
	46CXSQKCH5OdrU8t7lsodT2u6HukOk/6znDugm5SQ453C4oj2lYOFhnCFamEjrvNXb/VEOW+tj4
	9vABclLsfTz4QSuTcPS/yy2VUVKf+vc8Iu+xoveSdNjI6GSeNebFy4HamCaKDhXozW0SyKMl3T8
	T8+VpfJofpLbK07oo5M8loWTSbvyK7UG9Qxzobqd8HwmBTBKF5M8YNHsZMetq3Dqf2YgUCPPiw8
	LQhHLP+Hup47csxRv0Vr+VlR9S7Dd2V717mR26Nb1o19R3NbFNqXzBnUF4LuOiqhWZHuGQiEZeW
	lQaMdsHGgl6j2jiZGr07L9fQgoQl/COKrw6RVyjg09t0sdCYBAHa5haYixDMEYJp55sKUGg6kaH
	Z88kH7lMsYvsY4XgLXjBsxX6/hdbB9aouCtsGO1cE9bSCJpePBTAifgSYsDWuaVomHfSzA7qiay
	flKXMKV0TwFhGlmQ89QUzNh0AUduIKnkMH7mfNVbTOJLQBul1sdlouU7pQA==
X-Received: by 2002:a17:903:1a68:b0:2ed:205e:eac6 with SMTP id d9443c01a7336-2f03f16993emr29169075ad.39.1795175028725;
        Fri, 20 Nov 2026 03:43:48 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84285sm12953215ad.3.2026.11.20.03.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:48 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Fri, 20 Nov 2026 20:43:44 +0900
Message-ID: <20261120114344.3072390-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
References: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
