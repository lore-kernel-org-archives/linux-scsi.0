Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186771;
	b=cPvzU5KJoZwIbLyXBVCrIa6k3zXVLFP2araQ8Vxs+S2MJydI8MlZa7F5xNkNvR2ha59F
	 oJT41z+IwdsJJx0+3f09bcn8N1cJqNTved9evuGYNT41RJmihm8XIKAJ2tEIJfO7Zc8gx
	 g7Iw0wFz4mC9ZVTpE3guv2FPcMFKnka665kTnEUBhSUufrjXPCjzJQ306dZF9Wl1iPmxn
	 fbz1HFZh4B7PBkjA3XygpnlRZceG0Ersmtu5b8F3NZg4jwYNt3uuwQOdxMDncqpr63Wq5
	 1c3vw+aE1ZNPPUv39aE2ey6O83CwIM/OnFqkzupngoNC5nfmXq5H+TxtyLUUDi+ZpiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1/b16XGw9VrdgMUxGBBQFHm82uGKek6X08X7cWdHQvk=;
	b=gzaAWasuL29vFDA6Eh9Ip+UGA5YqOUwzwNM4Wk26FdIw8nAMBN9H/FnnSYI3g9VZGStw
	 qnpwQqY+5viAN1ZrdLmezWRU3LQeeX3N4fQMcDTiTRFj1s30T9bsui7uYLXWTslrj8Ngo
	 A2YS0PhrFs9frCDWOsp/K0Bjme+5FXKVVE9ZtU4LX7kVFWhfEr8Dv9jiO8abI94C+J1qL
	 4jhA/wSxT6T9hETAT3FqP/GvG/sxpst3fI6b6uX0d4aACI44LuNaEDV0Tm/DxXsjB2Jx9
	 NYF0LqniCMhirmP4ZNgsM78IriE5/owmU99Mi16fX4UJel3i4led1rJZa4xsZsaSAww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Lv9jhbvi;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1319606A331
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1319606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Lv9jhbvi
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2efe0e3bdceso4276505ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186770; x=1795791570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1/b16XGw9VrdgMUxGBBQFHm82uGKek6X08X7cWdHQvk=;
        b=Lv9jhbviCyWj5GwiJkQqnA2imalbM0Ak5DPvEtHey9jVkb/YeLossxhZ//waEK2KCo
         Lt4eR6x+TuZ4SuieYKocXIvNU2JDD3XkCTWEcx7HAKNhdEfj+IZSNPC4Mw+hPZkEOA5O
         RhC9sPmXG4XQlovwVthoY1rSbNdJxveFyYh+8ml/QLK78bZ5a9Uw5u73iN7YsD2BATzg
         UJ38spjs6zWCVH9urVctFri9HhMdr8/JejOVf196JTW0XscBsubYwYi/XniPEhrquAb1
         9gYVLdFF5wnB/SFZ57sEbnE7GLofUvJTDqvfvov2yQDPDrGIKX9S5O73ODaa26dtGtm8
         xzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186770; x=1795791570;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1/b16XGw9VrdgMUxGBBQFHm82uGKek6X08X7cWdHQvk=;
        b=x8o+/G04Y87ocmGUUDqBC1UkUwH54TsxL/Z/3+PlGE1mpAkZUQJuVU4bUvwiYNjGwK
         TnlHC6Xlb3YfEHoCPCTA1J9qSd3iTk207qXSD1DH9DHsyjDU2KY1hkIZIOPR5l6Z2ZmQ
         2IB4AEjndEdj/nXJRkFGmFkt21gmj1AzXlYYVRBwZ4Rwb46TGpO9kt/1vgs7HCkANFkK
         MbkG3s8LkbILhCYJcJt2UQ3gTLHmE6M2QUiaZmBoDB2QIonBvdn6yHjZ/cu2hxZFIy+d
         fcvqGHZegrblEZnbI8i3ngIWKsWYTtrdkXyMhFGhiJnEgQS3dDzzBJT+V1iU7StFxi/N
         nqbA==
X-Forwarded-Encrypted: i=1; AL+hErHaQ6HZ0/f9pCV8mPSs5Ld3kevTcpT/HSaqSx5Sk2+Dtp723u0IOe4b/MJyW8iTbdREbdcFYVRc4JA7@vger.kernel.org
X-Gm-Message-State: APuU4Z/rNWM1rfRxL1b91D9bw3bAiDvwLG/aMAdenw8nfqP7A/0pFgi2
	RZTsL1LQKeEgjrSSshc8VNEuPpgYFDnpC0qkaCjWeUiDQhKEpT9hvfJpnmJMVkxml/0=
X-Gm-Gg: AZFdTZfPVQpFnMOwgSbMat9DDzzhm7LH7bJ52H+eECjCXAJxAcjTn1XwXpR9vKOW2i0
	7YgdRvcqM0RBqtkQQ6oBwLtnEs0GhFgkCJAjFHc+W41r+Z0ZWJhzfSxexa0eV7WZK+0bVbA9YmQ
	qrjO2BsgQqd7n3tvLJeWi7gTGxbWftzgG1oR8sPrxRZ+JCkeOOnw5ckdGRv+s17XKCVcm5mJarq
	zgrECOvqKPs6BndRhLCXGrKCWO370awnflxxNXKlAvhJJfMuDYJsrgiSJ/32SWUs5JST5NOrNWo
	cMvDb6aMFrf4DaoqkCwNAeQ6IOEqwXx8ClDIii0CV3VfbZ4H02J2+437U/7se+wPPtmpAWJLrRr
	gjhjB+oX5j8x86GLaTMwD5szTtQj8lTJJ8SJbywcsHx6pL9LI7zZ2msjt2SH4njxcefCnpxMIoc
	rf5epRLQEEFnPsGfwv7OoxlVRP1hgSzTpjydxgdxSKTq86z+YRt0VmwdNJ0nh0pmDkL4TtlQHE+
	98hkwPZ5BCJQtI1gTJfTgfuhtn6iexL9HlGARE1MJlwMZQ+XUEXvfLj/E6THDfG67F6bdS/Me37
	kAWZwEh/yuFe62QvqP6iyU9uRynelWPsBrusx0cTIZ/sqcyUgHYjUtNAYi1+u+Jyg+vnxEbc9A2
	vyVtG5K7c6O+lZLrmh+bB8IG/pe6HEApII4Ev
X-Received: by 2002:a17:903:46c8:b0:2ef:ced7:9ff4 with SMTP id d9443c01a7336-2f03f1913cbmr36928675ad.31.1795186770125;
        Fri, 20 Nov 2026 06:59:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1aa3sm15445405ad.21.2026.11.20.06.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:29 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: qla4xxx: bound and correct the ISP83xx reset template
Date: Fri, 20 Nov 2026 23:59:24 +0900
Message-ID: <20261120145924.3127899-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
References: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
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

On Sun, Oct 11, 2026 at 01:02:55PM +0900, Yehyeong Lee wrote:
> v1 bounded the ISP83xx reset template read and walk. The review of that
> patch raised two further problems, fixed here as a short series.

This is superseded by v3:
  https://lore.kernel.org/all/20261011144752.2063334-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
