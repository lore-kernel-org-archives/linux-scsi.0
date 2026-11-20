Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186857;
	b=v+467lNApaZdm2IWKvg52SoOZWh72h/0grmK4NVbtuyzwSdkJUhnHZW8Dg/R2Is2WAMs
	 czpliPmOeYWSoqzTyscNheU5XRBU0qvLruFb/KCODaDhxMWfRoCcmkV8WTa/t6FDoxTHj
	 2Kar3kEclwbTojViQsanG4w6JXBrYRY/JIqT7i6PNo56eh6fYfE+AyGig66iB3AkdIHLx
	 CVAiVosjChqsFsXcvje95Xg78c2APs5vDUtggf3c3PAupsuRPEv087dcVLPDHGOOuLVRj
	 AilqLeC68LDevps44rh9BtA/DduuK1MxL7JXr2OhWpGltXeW5n3ge5OxmWOCL1DwG0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186857;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CLYhhjLA1rPX//UOqA5Kzlj7XmPG+j9qATfDArDSoQY=;
	b=YIJ0Kqyn3gsXRkm+C175rP0sDDQ/kmMLHFPelzcAQ/TGO9lUmXoAIuXuDf6QxJmUGKAX
	 iBgr+b6JEEuwa3Al2vQHGS41IMnBUvUFc1hZ7wRvb+IPZJZOwhtV0FwdLKgX/VVKjYw7G
	 u/kA3yF6uxEFd+Xa0NpSgR2ScKhD5KjyW0o5stpi8O9O99qFyupCoGAcUftsZerfFVwjP
	 dDUmS+Nbv5STONSk6PCrUBaGEfEr/N75LeLc8ufSMOiWNgdcQYWqRT2XilxglgpdYnZaN
	 K39NOfeMM4E9jVW85XoIR53XpklXxTgePsraiLFPSOu9IykCh8obIHf92rvolCUDZ3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OfFgzH2i;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319D9606B268
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 319D9606B268
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OfFgzH2i
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso613175a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186856; x=1795791656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CLYhhjLA1rPX//UOqA5Kzlj7XmPG+j9qATfDArDSoQY=;
        b=OfFgzH2iHlchoKwMpuHtI9H2gOdMSf4eimOyL8qKFyJ74E3pXkR7CFyP6fySVy3Z+s
         PNmscrscYms6054DTOGCJfJyVZEgU+G7qDadzNSAOhwLSuK9IWN5l/zBZ0uPkyBG7SF1
         YFty4HUE1LeEa/7Rs386jqkTstTlqZx3nYoXfOUu1OOQq4wtwBUtHxk026Wyi7cYlnau
         jYjTGbvUW/ZzYn/f7JPdzlVABLV791f2to+fFq2OkkAn+1MaTG1yv6gXbkdrcJuHnlC7
         Fuc9kScKoNZliCbsw/NdlbxreYF3ZDJYKZST0shbjIh0tY8hVhVtmtad4e1qD72Qu1dD
         f6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186856; x=1795791656;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CLYhhjLA1rPX//UOqA5Kzlj7XmPG+j9qATfDArDSoQY=;
        b=O294AG8re2oqzmntXmAxYFpwU0dOkFvr9E/5rfn1LXY2kxIjMBQV0FHiCQi509xTFt
         b30hgExgz9MuqY8OUmp9AuLcDmAIPBDB/p0mcTkdIqWoLtuebEqG3G8zFLib73r38Yo3
         CKX05fzqMCiMoiN13ex5bKXJ9RWSVRZTyrZIBmJbXA1XZRGcBDn60gwck/jtQfTYE5WH
         Bbvkf1gKbonHjCBunUBBuxGQRFDfXUbJ6KVAWZiI0mxm2d7eZWgYPxZyxvorgiYAjktw
         JRBtVPzoQb//ltBbyA9UI3TStlhzhXRp0EaRTdjEOFQyFYIbnkQetED1ZfxHAjwYeCPU
         +NoA==
X-Forwarded-Encrypted: i=1; AL+hErHS16l2OBi1DFyxg6zFLbVeoYExNnkzHTQqA4tUVSKdQZSJjPQO9B3aqTEM6LnnmGB6ZWmfEBjhJAT2@vger.kernel.org
X-Gm-Message-State: APuU4Z+Eg00JXJIr0O5wDmLo35vgjeBHrzmwaf1zByCz92N+gF5bQ9zE
	GNe6Wlg6ooGffFjD4yIbFvoMrZbxe6vOseijp9mWSmyAI8wvvbk+q2gggb0xpyCz76c=
X-Gm-Gg: AZFdTZf4v8L3zKjhzpIUdfadNlkmleetAq5baLuDNy9/j+nz6TP+hvKAfgHiGj867vl
	YvLf130C6vsiAw9+q1zX/2O5+DPExHVKxE3xgOa3Y3LfPSMaDXEv1xNlshAgjz8s62Qrc2QBTE7
	nnPuLnNKPW3iWJdJW9/TF8UgVICfEEJv4U16x533v1c5RpBCI4B0CElUm8FH/cglH0mfszfRSYr
	r/2mos3X/DdBPVx/SVmAUuePVDYVXyfKJVOYxRQvSSUxY/yHKHaeFD/4RZ6hhfYyMDsL/5JDqqn
	K9sfdqF1jkGIlhVg7L0Eav9KIWx/dsguNyMwQ/6fxha/wQngLGZT8NiIm23qbqRFmB5E+7ckCKN
	Ei4OLr3qBbZ0Ehd2nk1OF5mJw/nU3309a6VINB9JIRz4GVye4K+3uz3NZuyg27FIix7NpAbRzdA
	qravnLnR0knZXNI8oEtYBOeEpkKRJjtMrvbL9vGoW8mANlmmQaUg1vEdn3k/KCpxXHqraq/+WQI
	ET3lOPuxtBMjefG6OO5Jagw6ZFNSHIA+L5HaAScxNV3IBLNAX7lnpioseDKZVxdoYjkA7cz89jM
	9sK6bCYELr2A6rA/fXQhml9Ov4kHKL9RiSmnCrQKgKDRMa7Sbm+++d6ptUCc5Pvodoy2b7l85Is
	FFRbkr/sF9LLxNrwnpxS6CltZtQFOd+M7/FOY
X-Received: by 2002:a17:90b:48d1:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3b41c95b41cmr3118371a91.57.1795186856498;
        Fri, 20 Nov 2026 07:00:56 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm1333716a12.18.2026.11.20.07.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:56 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: bound the RSCN event list by the received frame length
Date: Sat, 21 Nov 2026 00:00:51 +0900
Message-ID: <20261120150051.3128261-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
References: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
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

On Fri, Oct 16, 2026 at 03:15:13PM +0900, Yehyeong Lee wrote:
> bfa_fcs_lport_scn_process_rscn() takes the length of the frame it was
> given and never looks at it. The number of events it walks comes only
> from the payload length the peer put in the frame:

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
