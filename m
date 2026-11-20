Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186805;
	b=FnLNIRmWpnJorGbjP4K6lr1BhJ2mHyrdWaqaoxr1NS+L14LMTz/+l0oewSf6QH2IUzfl
	 i62SClFbrhWP//F1bPJzuxyiR/OZwBD+62ImB0UlrdzNYTYLhGFI5mEnvSwlRn4wMwBDv
	 y9Y6otKRZwN3KwzX3YbIokV0TYrEX3wxd2wjUwpFhOwcYm5Rqd26ZN0s62N45gB9yr2eJ
	 p+Yj56TS1V4a2GRdyp/f4RwIpQBZZkNx3qe6CoPdEkLgO0vlivr/Eg5OlwpND25ytWzoC
	 PzHp0GEonkmO5wCMDQRMbksQm4DNGMZjy+mzRh/H12NM75j+zIwtyamT6B6+R0cNyeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AX8ypABi3H5bwl0dPAjM68S8RqBMluRIWiERrnWXWW0=;
	b=add3ZTPjRAOrVj/IyXeHzRSvgS6SF0wURD3dlw1T8mxAv3Gq7LtMyE/rYRdZReU7nzio
	 93oFL/3Js5jSNKhUNbVCyOM2lJr+eW0AdOzXZ8kPE4n7ojo16YEwDdrdtjCPodsC/v1mb
	 5riuEjuj8G1lNTpT7jmkPRX8EA03razJdzORCDTZxtRLEokBfyvr9Gfg5jiYFsg9WPdTE
	 2W7Xg+0do1iW/Yu9dlnTnPkDUKxg2mWipUUNywvvmUbpP5VFB/GdEFfDbSdV95UKrth8J
	 GGaqT+cJ+GGT2ooLSGNehLIuh8F8AGHBX9rRRzOFIm5capWqJ1RzVHqfcDbOmm4auTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z+aNO+Xn;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A0F60A5BC8
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3A0F60A5BC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z+aNO+Xn
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b40470fdd8so501737a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186804; x=1795791604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AX8ypABi3H5bwl0dPAjM68S8RqBMluRIWiERrnWXWW0=;
        b=Z+aNO+Xn6eVxfTqKm4KQxKsFnu+BlOkbCzcUW2PBVP5tBFbXv7yBl+JfuOQi2F1TdN
         58SlhxARbU6JNIYFvyTU8qQFa+nEXdtJFgBzjbn7qEJEJUppzq/O0fr9NDeXNFx/BkSE
         4/BNyTmhRvO8Pl6o/xMjLh5jpRQWfzqrzsTDSIP+8rgCk1T3h3sWBOXS3beu4pHDgOQt
         SBHoUQ9+JoIGE/2xXwt02o7XpSSDk6S/tAGLOS9piRj0pVSwSS/tJao3mB6yYt067/9n
         5wAoVrdQOfhYx32AGdbK9vxHZdj5jx8K1m7igdfj7AJo1Krh50hS5+jeacrtPqcYHTGh
         0nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186804; x=1795791604;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AX8ypABi3H5bwl0dPAjM68S8RqBMluRIWiERrnWXWW0=;
        b=nuIUqtvtEbs/nobjrhqhhw2L9TkzHxOdLGmlVgpvOVwdbC4Y8cGobeWQf+xureWagA
         kYcLbJQVvl+6I6f7X/qmAxED0h5RhTM3HrZjdIkNv8gnIYZjymHyUTVQF0tpoeToOXOS
         QyVGX3/i/gVQwwKm9qShihjJQS0ja5y4qcJjo+hc9o6b1i73V5WFvTB46hxUaLvAB0KI
         YJMbXzWiy6sB7gk4qoqZI897lg9fllSVIqsL7ydK9Bc4/En7ysGXITLFut7LDuYObRJZ
         s3RfJIPwlDkjgY1zZUzujtHjT4EJ2jJ3GrvPW9/lHBOEiE3xcwI6PaRS3O1bLdx1b8+B
         qAbw==
X-Forwarded-Encrypted: i=1; AL+hErEwE1DEZhP1GuM2/GwRk/cSCw2pWxhw92bf688VHFyKuV0qZ5i6D2qRF1t1G0H3hBOLUy54M0hLRTde@vger.kernel.org
X-Gm-Message-State: APuU4Z8496P05ADmj8NO5NmeZ9fWB27McQofOzh1bcHwOBvpygEkBzJL
	mWKnawsh+aMky6/GYd1dYDNbmLm7vEXEODILvb3PiZOkez+t/pWwm5dMC4X/wQVkjJo=
X-Gm-Gg: AZFdTZcTgPi1D5BfjnZw7C1xqSWnsQdvm2b4XnlwyLNNzGeJ3XZskCR7OAgur+XpNqi
	kxvgOF0oZuDUzPAK5dyjGR+KtS+cIhpqChgoEc5ElUnkRIdI7ZmvCdWHwrBq+cqBRiAqFnCzTNT
	LxJH7Yr5I+9/+5nDfFCqpbYK3f5yNjLCY9OSCTbVLLGDLlmJSuXd3cASsDGloEOL+78ybsnIsGS
	wpmIeceDTVsqeqGFj/czlyQnaXU7oHBFTJqmVcSADHfrR5miPLqVuQb36yzTn8i2zL1nyDmUXeH
	0K4smynDv98oIPfRi68lI3D4mUze8YyYnF5skVj2bX0doyzjbybsAGGHrdy8UIKCcyQkUHyCBMW
	ou7hUkxymehdDtGjJUS5jjxQCsumHaFHlyZLr2oSLc0/zmuAGLcCJZ9+C4swIiXI8VQDtoIpoNe
	NjpXlQovPgxUfEeLRGrQGYkIfZ7e50zIqMHP0Gi7Z3IIiPnC0ropvHBZPK4aDVuurZhiHRs226e
	4J+33pzz0hkXsp227YWMneJFOPJ+mangMWZQqNzsTov2bamw3d5nfwfzqzHyD+xVPa8N9fuYVta
	9yOW3cBrASUtOV0PcgT6iNlqDQqmGg4dhBLPe+4jivDwpPKtNw98uUF8syrGaRe2gMzpjeiZWVf
	Vh/MsZ7J8bgs/ZKHRZsY5V1xIRkWNsia5iW6o
X-Received: by 2002:a17:90b:2f8f:b0:3b0:d070:3c46 with SMTP id 98e67ed59e1d1-3b41c98a389mr2794326a91.12.1795186804158;
        Fri, 20 Nov 2026 07:00:04 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41cfbdd80sm2197669a91.2.2026.11.20.07.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:03 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: mvumi: bound two firmware-supplied lengths
Date: Fri, 20 Nov 2026 23:59:59 +0900
Message-ID: <20261120145959.3128007-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 14, 2026 at 01:16:18AM +0900, Yehyeong Lee wrote:
> Two places in mvumi trust length/count fields the Marvell UMI firmware
> supplies and never check them against the buffers they index.  An event
> with the maximum param_count/sense_data_length makes mvumi_show_event()
> read past the 512-byte event buffer and into the log; a handshake page
> with frame_length >= 256 makes the checksum loop, which uses an unsigned
> char counter, spin forever during probe (shorter over-long values read

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
