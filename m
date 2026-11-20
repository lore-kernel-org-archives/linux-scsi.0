Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186886;
	b=HxcqaUt8TvfE2ox8eRhDAhSWOagaIrEzTaPn8xGDh/3YcDC9EhqZVuIHv6qRSEsVDNIZ
	 DaPpGliHoGprgpJMYr+zfO0FFz7tPhR1N4tmfDj8P5yEajy43GAT4XTrH3f9IRxA+BjnT
	 bJRxxgwvfxqJqvKDjNxx6FIYc405QgE5+IgrFmJG0lNX8F2iNE2xlneHYCzQtEKDBdgbV
	 r3i4mRU9hcC1KaLncj6K3Dgg2nsl8ccOTSQb0KXFJVc55Cl5kUpkey9OEZgNw+pyi1d+v
	 S0i1vvyfh1EHq2KOazclZcM3LTsqVhRFhewriBJRM/TDaS8k/5n6sWIXpcFiAVipP8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186886;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=On43ZjoDW4xM+JQZ6p61QSzbWqphWK8UKiGElZsBgt4=;
	b=G71a01D9W7TeQC2cTQkJ5v2KrPyOWbGs6piBDXwwMx9QLjhoyiZZHwolpbSF80DQpf+/
	 JtOItTIVT0iHFGzaS1Lfa+SllKjaPgALpMKkFAxEIl37T9IizZsruCcEboFj0KRBKPcFb
	 muiFvuN6TJKBF7hcasdAcbmJZWp7FEri6Ztyo5+j1WPXOYzwxhPJOdJeaf4ditCOyCdjj
	 UXzUCOFGQTnZ6HXCDcjtyTCrggM0/hWqfg1zOKubJKnOvpwPvURcaWEiDAvhFs5uAcE0j
	 IdHCdB90DReilqCmBfTdVqol8HtbIDABcsB/XNEU+BRQV73dr/U989xU1oxrNS2CE/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GM6oAl9C;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901260A5BE0
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7901260A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GM6oAl9C
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cddc597d062so584050a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186886; x=1795791686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=On43ZjoDW4xM+JQZ6p61QSzbWqphWK8UKiGElZsBgt4=;
        b=GM6oAl9CFue43yNm9QcWrcuFp1ifdnNPBc3kUji9MzL2NduZ9VNGmQI3xisWK7SKm2
         JnmEtGRAQNCyU4TocLBEn5ziwAOdN2wEdi0f5tRaoYyV+3fcHRDobCCoecOb9wXcsKIq
         A5H/rg6NStaIwPMYUQQRAGO+p9A1zwnustJ55W7Y7L0ACb4noZC0YFsEiYkA2d7UsAx2
         UX2dNi2hy/UCkPbyTHY3x1ZJVZi592IZeIkcSbZFMyDlLam0pYnwINh1ORFHp7SNHHV9
         BDkz+QGo71BCjnEREQC0yWN9NdpVcXXd3HpYq2OBIHp+XRWNuiT9bhidsRRd5tw5wqKX
         YirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186886; x=1795791686;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=On43ZjoDW4xM+JQZ6p61QSzbWqphWK8UKiGElZsBgt4=;
        b=maDadWl41qbMmGjq/2Qx0ya5QMd7vGTdwZdOhLi68CuMJZS20JR7WyCuyNdHj2aOb+
         QK+yV8ed4ghtmcpa0gQOrwZpN5xqbN76Mk7cNB0t5h4ysXYkuIusLq3iyIlY77PXhinB
         0sM227sipFYwAAT5SJKcp8CsnED4wAJn1WWi9qdJuLDl+i9UKD/C5zI3LAmEvWor/0Z/
         OWZceV/O+drJI4tq5ccmD+ctfYBdvUdOB4JG/QUuL8gQDNhkvhQE0a7XwUma882Tno12
         eAQvwciL5VvLirMomTOubqeEHnHQwkA4XZ+FA//SvpycRLyh8M41EHpSsX37dFpnLq3P
         mvjg==
X-Forwarded-Encrypted: i=1; AL+hErHiG7OkulxhGZu4aKp6rwymm2zK9TT4LeW4W2F0kvjt4FCvDyC3Uy9jHkt3Jp15ppoZwe0KRQTCRHPS@vger.kernel.org
X-Gm-Message-State: APuU4Z9okUSNR/alxGJHVVrQ+9H3dM66/9yY7AmlWSUb2+M8hKXPq/VD
	AQkL97R4kE8woQWMAXsLOspE3WfUwX+W+VNabJqFAFfOY2HqTBYQWQZWSY/gVrWY1eERkDaE1pW
	SvXqetiA=
X-Gm-Gg: AYBFou1M5YL1/RwAqdfLvkfJgVh1BWd/ta9AgwKONVjdIT1vXvlksa4rxqp513VdJHA
	xJPqFDjZyHS2oXoLPTGb9gxdLXpgLb6kQPPupQ96BcasdG4o3EB6zKOv/jHHcbYaQlsnMZ85a04
	SOIPATAZz6JGSvHVJJy7b0iRWDekcjFF1NeJzLi4ocVm5Ry1PWbjLSkz8Xbsu9AflASTVz7/nHK
	sU9HSMJWUWASwzr6GAvzZNICZ2DRVRo0O0/VK03LWQ3nGmK+WFstQkzYDLhFzTJrumYfASFMHim
	jghMsBC2emecjHbs7KduWoOaVyL7ZqlI/2yCiILyZGbUvdKLdlq/e4mqAELmaWi71d3NBQKsVVF
	lEyTU7BEsS+szZAej8VHcx4tQ4W2j2+doskzn6Sp8ogQ31cEdiTYl1S1/xnG6Ivdl8I9JcCY2Ut
	1vednSIo7US4n6jFkrtUDFHGwPCo0hw+NuWY4EUv3N02uknPBGZDTQCJgzTWlkqgkDGW0UJfBDQ
	rwjLBgvq8iyGKNbIU9YjgDroRKToQXv75z6fQa4jdHlqF08uhXZFNKzrRnQTPxQrluf4ZRKdHLp
	xmqVXaI7/+6yzrS35L65Gwm/Gte8xvtdclYiC/GxQoa1XwWjnczjiEGKfTopQtgpHEq2F9/CcAb
	OxERx2pHlXb6PbEzqgriz+uyeDI1GHks62B8mBcSC6pYyuyD/lqU50LPoZg==
X-Received: by 2002:a05:6a21:6f89:b0:3de:7add:6551 with SMTP id adf61e73a8af0-4014ca444c4mr3490315637.16.1795186885908;
        Fri, 20 Nov 2026 07:01:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc6130sm1474521a12.7.2026.11.20.07.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: jgross@suse.com
Cc: sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH] xen/scsiback: unbind the IRQ before draining in-flight requests
Date: Sat, 21 Nov 2026 00:01:20 +0900
Message-ID: <20261120150120.3128351-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
References: <20261109122654.30859-1-yhlee@isslab.korea.ac.kr>
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

On Mon, Nov 09, 2026 at 09:26:54PM +0900, Yehyeong Lee wrote:
> scsiback_disconnect() drains the in-flight count before stopping the only
> thing that can raise it.  scsiback_cmd_exec() (xen-scsiback.c:426) runs in
> the backend's threaded IRQ handler, so a request can be admitted just after
> wait_event() has seen zero, and its response is written later from target
> core context by scsiback_send_response() (:347) - after the ring has been
> unmapped, and on the scsiback_remove() path (:1268-1280) after kfree(info).

This is superseded by v2:
  https://lore.kernel.org/all/20261113110036.146860-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
