Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175019;
	b=g4CfDAroZ3K+K2b0Iz0MYW8JiV0D+KTd9DNavKrFQ4W+7ifsP7k2oRSYxPdEDtnCcCYU
	 vG6x07MsJe2tidgV4PzNywwAZull4PDSgQC6DnhKxnRHnnZxxL8DtYfVXmVWKII5vZ3n3
	 dJB0hrxJkQIcqwYHqIUrW3IFzsE3ng2ybP5hWatvQ5aLu0wmaxCOg86IC+B7HUW7GlfOn
	 DECTPa9+ugHmA8fpuiZrOJGheygakykQOhaA8LVp2tlVxdMvW2Ozxj+NPJ7VcxK9I8Zyl
	 N9Pho0A0iYva755DW9K7d93IKlQHM3CehMdqMXG4Sip3oFMhCL9bIOokUiNw2JCmI/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=KsiIXr0DSqrQWgZeARLB+Fd5Z4ManVYgD8C/g7hMR9GyFhnB1hAvW8nXj69XzHh8ggry
	 rgqcBCGghdqvlDulptWw00+QthlD8s4QwvJF4fOaPv3zspw7DHqekTa4hW1C8TxY0cXDv
	 2wipLLQKk7l+aTWByB1p7jOkxKDvATMGC4XQK/n9Xca3TxCWp0VCzyztoL28wLljqm/hF
	 QWYi6qthKfB0mZPfK/MFMbsM+6mCu8R578Bv4dE2a41o07dPPBmIavtvi+iV2r8UyUtIR
	 EcNoy60xdLOXKRsj6OQZZ9UCJP7WFQjklMiFzIEtvXgiRudf+63ZkRUMJlaXXFE23Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="mqRu2u/0";
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3D960A3803
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C3D960A3803
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mqRu2u/0
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a60f90a924so318123b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175019; x=1795779819; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=mqRu2u/0RE0z0w5EzgfeO5J+i+977IL4HjmmtHZryDVnHiONi9GdXDEoPDWRUrR6zX
         u5/h+FnSs2NE7wmFDVzYmMCCpgdPoNJRXCvbzsQ/sR1Og/00uk0tXPLSZG4muo6rz2hC
         Dc29fePt92Bd/Rfzv94lmCPOUDy2WMTdz9F8+ovUpCtZG6Qy7LH79zgcE+VdR/gEBREi
         4gmfcF/HPntWg/z7d26R8D+jNpQJ6C3wnoJ3sBoRVOuuUKEBiwOuJMZbOwtwxshU4e9b
         gNAWPXFBbZ4R3yAx253NjIs+HMEJ5+e4hjNss7T1bbGzaOr0nKmLL5tqKDNIZpc29RX3
         4cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175019; x=1795779819;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=MnJZmwyDD/ZVuKCeQUf8pTrzjrn22qKOVmb17NViZILaNWWi6uMMgH+QUuSZl8yUDs
         zjj6TB3ay2Ewx8idrMh73c7ifsFPzElmEvqAimYK3ujUJDE89Lcf6QwCZek+ygMBBL54
         r1zQ0LC5ddF3+EBhkG+XvljtrN4/19k8H0ijEE9dFRJypjypNeIEkr+tthbM0IohNrDv
         k8mCXmEyWHCYUglhzVh9i16kWIdqwY9EYSAMTu+EH+VO0z8VvdAN4oklr2j1cocRRrzY
         LwyCkXL+Qqoaa3fEUg/4+3CG+dJXLIPZ4rmlQf9EM/hJ3gEsTHGGzQFvP21Wm3E0e5sl
         7aMQ==
X-Forwarded-Encrypted: i=1; AL+hErGUUBe19+rhAuLoes0IpklSJluDb3zOcTAkDZTmHy+1kIb2Fc0XgGr/dIX7IJDsTwr/drT8DlEM5kVi@vger.kernel.org
X-Gm-Message-State: APuU4Z/HrQ26zT5zQ+lRuEAXlwdVKTCGYbHGxuspnCIe1IsyHxHYy7ZS
	0BGFdHdqtfHqpbn3mgz+YwDMg2TL7umeYDolP9A9bbIns8r2P0ZHZj0qVnJbPqwct6I=
X-Gm-Gg: AYBFou0K4tMOEgE2ELN+gXYcet8N3dk5I1DmEAzaFj12XgCdtq4iMoB81Bq1HEbtIbs
	uM7TpfzJ45uwymnI69jBVsRe3twwkQYfdxYgTLdNVcgDd550zuokup+VF/NZjX++GC9AwSXCFIv
	LtW2mZ83MmcDzAxxZS447UaWkfK0rzoSLIpWQSXDDHo7sg6tmtUBxasWkOP898+QHuSF3aXeIiD
	SgSPIsZKkydwwYEBKNoJOwHTC194UMyxQP+Ru7JszWP6kzsduYNBUjInO0Ugjdop1zhVb9dZe2k
	4Sjsgii1Pj0ctsaVm0LEDIBV/g8Rdn7NMJd7pZUFVG+Jyy521dDwDUxUv1Tr6feDoxFH6RAYlBo
	fhXOej8SCFLLkoUFxj/Ju8wBFLAknpeVYFuptpmotSpqzkk+SU8FNcc1zWVF6moCQlZkx525nHw
	+5x9A6Bb5nnhfVqtWwPaV+9v+i7QJlEeIN3sixRTDD6qfI0rO6UDQHJSyJBDLeRAT+Cx4XHURTO
	B2EdPYeq8bu+jNqJcyOlJsvSlC+5LhtDsduSnhB+orEcsJ8Mp91fQddmRob5DrzdxE7wO+slwxr
	DA3v06SjiOm4ULhuJIZ96ZtVQRY3SxrgbsSAfT/kN53oGk338CnCD7qch3golQpXNkDxXfiL+vE
	4kuse38sSQkmvyxxlnL1xhIIxz1DMJDVlpsFI
X-Received: by 2002:a05:6a00:4149:b0:87a:3144:8c4c with SMTP id d2e1a72fcca58-8c87dce1bc8mr2671357b3a.59.1795175018797;
        Fri, 20 Nov 2026 03:43:38 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f83dsm1386231b3a.39.2026.11.20.03.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:38 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: mvumi: bound two firmware-supplied lengths
Date: Fri, 20 Nov 2026 20:43:34 +0900
Message-ID: <20261120114334.3072348-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
References: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
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
