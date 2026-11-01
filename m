Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793515085;
	b=coeSG9gmfj8OpxgEDsgqXoqV+KHfmpI/cQk1/aXzQ40OsHT/elI932yJF8uYqdM3uBtm
	 iWoRp42uaxrhK1kavd9A34BoviXvFOtO1iA9Eo1Sv4ID5H2ZARnxolk+ZCtLvDbw66oLP
	 r+RfyuxwXXoqiCd7vfjM1CDQO8lLtGXlGsN184MPe418ho8GqzErKnPVjvcoYETThEXNS
	 utjJq1+GHDaifF78iDAWlVuKIxxp4EZqaMRAxejPoCToLVTzYjSH8ScC7+MkYN4gYK0bF
	 AnJGPlgK/QWpn6Fe1RKNZlniVDlFu3rbmfbj06yTt1BWDNhgN5DkTUTZKKMmmY3/DQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793515085;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=e+pqb9ytLIFYoIlSdazW6GvKKk9NtjSLduFPWkr+QGQ=;
	b=Ed9U7xmb4CCa4nImYtFjtzoZDuxoNATGfiNyUF4t7hoPlcnUcqOJCnJBlhOx3+pvvU0b
	 oUdsYfVNUFO2716hVzI+6f7nuybIlFsUo8sk7RKUdGoeImSQ/W0GY331yzvogwICPQO2l
	 V2A2BuDutrZgrTZj5Myd/O5EyqHmOmcHjiwUzSRRXVhAD7xCULsTTHOemq4w5T3s9exdg
	 iCqfJfhyZmp1VTUmub2cSGamDw6HWhVYkPFA/14hu61T9z2Oli5P9WlUQMOiT7hqqIXnl
	 biCXNC55djMxhBR2NUR1VgyOD/yvf4EjL1HXwgE2mvLjJ8RhPw15JOvOohQYY2zK9cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wn7Myod5;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21947606A327
	for <linux-scsi@vger.kernel.org>; Sun,  1 Nov 2026 06:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21947606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wn7Myod5
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab41538192so1700099a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 23:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793515084; x=1794119884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e+pqb9ytLIFYoIlSdazW6GvKKk9NtjSLduFPWkr+QGQ=;
        b=Wn7Myod5gDe4z5Vw03yTXiszN/cbKBQeNsztxuV7XgI24iJJI365keCvyL7aHrQm4P
         ZbIkF7kEnRgrb/ZoJlDmokWgsKHIHfm+oJ+xQrg5E1SPLtuaRWD9r6b2C2rb2h+h8Tfv
         NuLaJ5AksPGg4R9IGacllS3+KviLjfwg3ZEAbftKwzNoy/KJ2ULqusVNSNN08bE4Win+
         UkqYpLghC5gmaFwWPTlWwfGzxLkbscrhJlD0eOPKWtDJIcUEWVeK9/LATf6CflAG+1U7
         m3zhacMshTyaS4MqVPb8o/DTYN02YY9jQ6IK3ulwUsun7NU+c2W2udupQgT5q2fobIlJ
         y6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793515084; x=1794119884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e+pqb9ytLIFYoIlSdazW6GvKKk9NtjSLduFPWkr+QGQ=;
        b=lZna0Hf3f50LiMQj5g2Wj7IjTBbXppeGYovT7ARUx2P1GPVV13qieRroqBglQI9Iyt
         Csv20yRk5YhwYlRWAhlLQQG0XiwpBhTaG0RU9KiOqMK4qES83mMAsqzIArWNIn3edYiZ
         hG+oc53+E6SL5jD6uRHobA2Jt8YHCVqJCscd8Ce01YyXMH/N+gJmjliia8KuR8rHtiRW
         lovDwZZuOH02pP7zffB7WWh8DIhHt6/QuqL0x/yMpcHVp8qDghh4rzLEL81+TXA6Td3e
         YZD882FCF69Jrl30giaozo4d1TFXEDL3sXCv+0MMLvc5SuqnLKmZGBAK4BrA+a9uzQUI
         el6A==
X-Gm-Message-State: APuU4Z+ZUlVYAHiihlADZ7jl5355GbrZ9j1hhea2DJvJYkIBrv7Vyf1Z
	o++AJd8yXpaN06h0Z7zg6O0+fnKxeNqhJSLRSQlPTx4NweHj4LbvuNcX
X-Gm-Gg: AYBFou32TZwSDZVuJy47LIm+R/osjCsfTUBF5VVGCdLXQl+EtKRUOKd34QPmxm1YZ+N
	QwLAqzm2Mw/VfIjrXs4ev3XMhphfP7wA8av+kfY6Lw23mWs9KgYcxKyVdlBHp6PrTTayF/Kv8T3
	/XFX58WqCZYd065bD4tqHp9dq5feyFMirFGAnduVSiiHzbXiUcZ8U3WPRwEYrsd+ZVQgPi0WqoN
	YNvcS6KbCkmseZJg7YV3Thwjm1ojFE6kWxnWvq6GCUPat3ANrhR9VvDHEdk8aMiHma9O+lUB3kQ
	CH442BNgnTYYSDZZTdzn4REZKmu37YWdHN6Zaen7oD/Vh0zf7WSSg624y2QVY3gslD+3Mp0PfGy
	cunzbMPb3GXkvjV/GpgCmzjILCky4z0dqRfvX4JZPhd0IR9k6WECssCNw/H4bvP5QbF0Jjsbu3Y
	d7ngto9M9IuEAwwhAeMRemhjdKy0mwQMApTuuTxoDFhDlE8qk8an7frSqY6CBKjxrPvcYn0iAzd
	0XFwyTUwR6AmAds4uI3+Cbd4GaGS+zMSLAix5nN5Ub+2qgCcyEP/5Y/DedtLlYWMWVvb2GoOWKG
	qOr42HllTZbsoHV0lpnveRBKrA9Ax/kY6m72jXpTC3SbIbo=
X-Received: by 2002:a17:90b:2d8b:b0:3a7:ab31:2f4f with SMTP id 98e67ed59e1d1-3ae89749f9emr5379084a91.28.1793515084445;
        Sat, 31 Oct 2026 23:38:04 -0700 (PDT)
Received: from ubuntu24.vpn.host.chaitin.net ([124.77.157.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm14036712a91.9.2026.10.31.23.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 23:38:03 -0700 (PDT)
From: BeaCox <0xbeac@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 0/2] scsi: be2iscsi: validate vendor command buffers
Date: Sun,  1 Nov 2026 14:37:52 +0800
Message-ID: <20261101063754.89598-1-0xbeac@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches validate the vendor request and DMA payload before they
are accessed, then bound the WRITE_FLASH copy by the remaining buffer
space. The first patch also keeps the allocation size valid for the
caller's error cleanup. The second preserves the existing u16 offset
interpretation and scatterlist copy limit.

The series is based on mainline cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a.
Both the first patch and the complete series were object-built on
x86_64 with gcc 13.3 and W=1. An ASan/UBSan userspace harness extracting
the actual function detects out-of-bounds accesses in the original
code and passes 2593 boundary cases after both patches.

There is no kernel/BSG reproducer or HBA/firmware test here. The BSG
entry point requires CAP_SYS_RAWIO; no unprivileged exploit is claimed.
The local harness can be shared privately on request. Feedback and
hardware testing are welcome, especially on valid vendor commands.

The analysis, patches and validation were assisted by OpenAI Codex.

BeaCox (2):
  scsi: be2iscsi: validate vendor request and payload lengths
  scsi: be2iscsi: bound the WRITE_FLASH copy to the DMA buffer

 drivers/scsi/be2iscsi/be_mgmt.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)


base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
-- 
2.43.0

