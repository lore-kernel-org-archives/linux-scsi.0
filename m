Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186776;
	b=2lSSkJ9wDYGHGrJw/OxTIl8GATuHIxDKx2bq/XmOCl2hfb1mAYF95QTeWHOH8HZ32R6Q
	 rTshTXmXEhtVxZfpBRZ7yh4KLYaouMuQB+X9Ga35uHirPURvrYaKHKEO2OqAxH+hhyoes
	 sRHHskChl0RlKzudwTUisUuCh0Dd8IpTFFbnLXX+RFqMWrvfsYpwT6aVlfSB46XBKKa1F
	 LnlV9py07KxiSWkQQsYETm4s0UYNWPIiuICKkIuA2yayWU7KxLJcDLuDc3FXLF0yPduBS
	 7lhCEUb5jP6Ui9NwGUcg1EXoKda8dilA2DUBrt/JljfOnZUDap3qz2RUUEt6dxtUjUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186776;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3eU7JUxr70aXQRKZU7ZkeRq7K0s907+g8T/hNFfZDVg=;
	b=M76yqEq2pHIYPVgEaMnS6MCeIzdgT8Cor+7D1M7x8UzvNJ7l6PoDgN01HnEZH6/tDA/1
	 pO5kBJnTk3Jigp9KqLoE9JqxBsjzAWLj1jnzlZwNzbkIcOlGuO+POyAkTr8ffapgFAKzS
	 kUoe1MGKosKZlKzBQwWjdJ0xK6G2iSxSyL4jILXIooV53KjeHV2nCUZ7Ft6vkNcD8+7/F
	 QsUCPtE8WmkjWOFfQp610GKvM1CEMsP5Dd2+dk/zLL6bQHhGMHDIVPT0VPrZRFPWE9BDX
	 El7miUE2rcSaPA2R2YGQQP/OM8hYRwQzAidVYA32bGUeD+Xtkbl6cm6hqK+kedC50ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d+WSCsrF;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDEB60A3827
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EDEB60A3827
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d+WSCsrF
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f01f296937so7932305ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186776; x=1795791576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3eU7JUxr70aXQRKZU7ZkeRq7K0s907+g8T/hNFfZDVg=;
        b=d+WSCsrF/dWLtuGfnnj5h8t3Yl4+rnTgfOdV2EgLF9EmHtEc7EINaDI7qKNbjc7lG1
         zE9nYv555oDImrohUlODnlofAr340kBPtlK1F7Wu/1DxneSV0NwHhaG4hSr4FEgQpAGJ
         bt3Aicw+ywy0FP4kUY5Yx28HkVFMLruhPmJZcsEpJGZKRz4SJ0f3wP2Xs7Njj0Ve11tf
         iebUhj86Bh1VIaqrWuYeVL3nU0RwLLW3YPD8kI8J8V0NBHA8p4ceQAIflvPSklA2R9iY
         Ia8UjGQL3cEkbnk2paP67LA8wAbk4a1bMPIo0kCmM7iPBH1PwH5zKaRzPzeVhaNJiqnU
         53/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186776; x=1795791576;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3eU7JUxr70aXQRKZU7ZkeRq7K0s907+g8T/hNFfZDVg=;
        b=VTW8rRnsIw3gV2Rkaz9fU5GvKYAPS2+wRlqDld8nyEDr5i01IFtHGCPXj9+3zMFqJg
         yuILGd5raLcEZvwx3MuNaUpY4qMycWqqojIZugdpCyf8kQq78/kD+6RXvIF8R3Qurqjq
         8oB6fBwymAOkwduQQ4yovfopnjcndMxOieK/2U8f2BOcr3IIBGZ+elvNA0w3Ug9eGqXq
         u2Zsdj7oRU5ijf5JmAfQMi4nJPG8+KKxlDzCUaAQ9ow2MabxjdFNNoHgGI64cJkTH64I
         NHjqf+KSNPkrUQWTlIGcOJ+NZ1YxJ2Dz2xv2qdBmZH/e2QPjJUHK/5FyHPd1c6XnaM/0
         QqiQ==
X-Forwarded-Encrypted: i=1; AL+hErHT+b72c26ktdtTSPErBIWiHPozUeYvQLFiB1fCLaS9cSBrZ6NfZpSnCDCV8MiYytYpvg4SRt6ApBfQ@vger.kernel.org
X-Gm-Message-State: APuU4Z/LJoxT83rZnf8swoyMJcWw1vYVR1WoRCbQ9jFmLv9q7s3KyySZ
	N2ZtEaZmsSmVvg0JksZBtTf1/b47WEvnwDzVhhu+XzwpzNrxBoY/BSxlpiwpKgEJUbg=
X-Gm-Gg: AZFdTZdixn4GCKrYBllbxlfOW3ZmTshjYgNQnHAW+rrfbI8F7D1PWdUU+0eF8C7QryS
	vC6ErB5PaiipvSo6qFgB9vr/34x4bnNZQKtuLrYYtRHGzStsQVnFCmTxmp7xwIf3r0Gv6oo5MtX
	zrMxbpB8vVLdhNE692CbiYvLz8X28y1TH9H22fANmnEqKaXfFOcW2TFpauaEZv2OvuOWrQc5+LF
	s9ScKQrRwqyKucY3tOPIDNE4tKueTux1XEw4evAlPXW8hrcmnf13v2U5mYmfbAOTX00madHaohV
	4+puUxwIgQjx9Qzpf+Xla0A5Zwx7tMg7caEXSPfFkTzJelZ6pS/bNjfWhEijVIPJpqJ1pgIxgup
	jODWLdVUNt9QM/AGPHIQDx7CUdt6WWT5bKiohXHJVQ2PE4D7+BgpZPFeUCB6L2x12TFLBO7yRJ8
	3Ioqm4WrtGvDdz36wKKlC/Y4bk4f0GJtmpocef15APLeTqpF03ZS2VvThVKfeBOyNBoKcDsBQVl
	mn8lfgSpJMUot8w6KmD8R6PRXyYLG2AWEp4quYoLzhzU/XTs/e/aIipRJn5XGA1Kxx++n0Lkc1+
	pYKPtcCcMTsq0c3y9JR6vpVEKRxbnYBFGIqGbVktherBUIksTdeHFgfmOVjYhefmlxMPPt/+qcl
	VcK7inOxts8w4ipPOAtChyIbPM/V8scwpEXpf
X-Received: by 2002:a17:903:1745:b0:2f0:5b55:edf3 with SMTP id d9443c01a7336-2f05b55ee4bmr165625ad.32.1795186775567;
        Fri, 20 Nov 2026 06:59:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84027sm16016445ad.7.2026.11.20.06.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thenzl@redhat.com
Subject: Re: [PATCH 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Fri, 20 Nov 2026 23:59:30 +0900
Message-ID: <20261120145930.3127922-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
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

On Mon, Oct 12, 2026 at 04:38:25PM +0900, Yehyeong Lee wrote:
> The arcmsr completion and message paths take several values straight
> from the DMA area the adapter writes -- a completion slot number, a
> type B completion-ring index, and an inbound message length -- and use
> them as array subscripts or copy lengths without checking them against
> [...]

This is superseded by v4:
  https://lore.kernel.org/all/20261114033810.549787-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
