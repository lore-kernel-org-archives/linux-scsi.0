Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186716;
	b=L0oanxI+ZIETgoGPPFBwv5rTGEQpxTGOEXx7SGCcra33zIh216DIrSC6XGI0KmBGtc+k
	 AkE0s9cXeuKXl70e+VE2lYkJzcmoKsKuQqCbFVqTDGFqLDNM+17SGBQ++ycEUM7PGP1W0
	 TAr0IwRU5bnRThEKcilMeY05Y1FNNEJQ15gOBphGxlwrrf8aUcqxvNaJLmoi79tEqJgYX
	 T562zUc4n/2KFE06hAIp7uNnhAyo8M3/D7AcBfmKa0ZLY8T4jj7sYaHYCGrp2WmrsS9NI
	 4EMl7hRkyG7moLgdvJQ+HFMnWNU9r+0Fl4ZQUW/bpKVPV+FbzXykA8UqQBJvDfP6dbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
	b=ftlbRq74R9IdffZW4g2Mrdjh26dW1BLn1iDQpDBMGjgP3bmALCc0i1mxOnA/SbiNhict
	 KVHqK0RLriQR6n5KJw84QhEB8wOqlCsJyVo7mV0yXLCsHM4VZlgAqVkXdZ6ydLIs8l3+f
	 QErLdRh+MXYaAj9aV2UgBFQcQ0zuVMV5t5mfcCqK7mOSsNFbDy7zluKG5iFSzs6sZoMhT
	 wT+AxqZlAyr6N6avpWbd2appbT+yJalo3Gw/h8jW3Y8nSkGT9LAgxrm6J9fTpKeDSGoF6
	 9N/F6irxJLF4IvEAaKGtPI2lNnqEdwoXM3ZcfGD/JCvyA3cGuYeUzZvx5k/QOzxag2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d09wDq7X;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4F960A2613
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F4F960A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d09wDq7X
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f00fc215f9so6728345ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186715; x=1795791515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
        b=d09wDq7Xtf/yPNUSUJC1xtX71TCCcLQmg9nOZHtNRXySR/cTI9/Kjr1fu/DTA3OEo8
         7rFZYbsu/Ym/Ilmxw4l/Alq27fsy2InpNapNukXUJnHw0WRneub2rkK/wqWocYt6i2l8
         dFGn05K1Qh6MMOaor543IAdOKMwtiny4PzbkKeF1wRTJ+k5/tVZDrHzHvatlcO6sQswa
         4LaTt1OK8lbY5nofBw2A7hzMG0ubuqKS0rgOOxNa/3P8SoqfvarR18gdmqGp4cJesL/q
         IONyjPStAgcVuCgPfr3djILCQxsKUlr3wcih3buL4AjfDDmkixXm4TTW+mE1nhk9bXq5
         GEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186715; x=1795791515;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6G3BuQHqwFY5tfzNRea1k3DGO2evCkbLdAqXG28pQs=;
        b=HWgbne1/yUmk0VdFjXklk4HzjPe9Zw8cpt/jj8kbRESPO0oDyEtu0eVdO6k3sEtw9R
         7LjzTDGYW+wLhOnqn2i2GBVmktdAGqSjTfvfZBixQWIP2YMKalmLX8JSee/ed7Xt3Vvo
         uBB1gannBlvzNAwbwC1t4Yz6RR6BNDyNwu8+RguYGwGroDqoRhDpmzcXKgjVztv3QqIH
         p14JtifE/DSgBdZ91CNdLtC/5n6rQ0K9sLExv8WaD5adGsS+mqUhcKvPBpvyo3dVYYYu
         fE0nXEE1RATd1HktRMczJLuv8zFKbdim3tGmDJ3gCfp4lCjyH2815ttF3rHp6sPoRWsn
         JzHg==
X-Forwarded-Encrypted: i=1; AL+hErFnj+UOta+/oU7fFELvy8xYsaMzq7V+G3D379wbv5ufeF4p5MxNKAA2ihCtE48zdp1FZsNRbaiYv5nS@vger.kernel.org
X-Gm-Message-State: APuU4Z9abaikYx6Usrho/fJ1uKKGZlcrBKOW6kYIjMnjmInsm641gej8
	ksrAtMqQlC+T2PRu8P0pI46+vccYg6WGKl2NaHQuCZ2gU4vFRLis6htMUKRvQp22PLA=
X-Gm-Gg: AZFdTZckCWbdzelbhe1csuv23bYz52Mwot253lHpFyucKvwMp0CzB7hrGnwo4h8uNvD
	QwoHoEaagGbLKUCKvT3nIUxjVJxryW4fUjXAc2jnVpuKNyBFazwcPRJ0hmWrbrpZ3dgjvsgY1sL
	hrdltv5NhAGSkF/uxVu4JiZrumA88DlCHsVDyC3AiWXgxGimNZsktDyavH3YpFz7X45Onhm2gyt
	PJiSgSHpp/1PYUtinI/wda0UBLIeLd8cx30byUSqTWkMXnuRopo+JsmDhrRvNQcw/mIRQkZHY5w
	HIlSDZbpqBZFlUn3c/M55FOzWsj3g4fGCMuGD2zL6oWKxz7Se4ORQFfKgCdi4yp0U0xvSGt+MBX
	yBdoY29XsXVnE0rDVFrm7JF6DgDOdhoHf38loG1h+7g+hZ+eCIx5Pka6YSKyHJGXcQpeHkaU43L
	gWNcVu7j2DAHCjfcGW5E65PYJFkUXvTuX2BtpQdlcyltpt9C+zqdATFLizUv7XivHMjl4a4j+Ru
	ePFrxMyjznTXuCVWA76lwxTIk9dbcFemGYaARCeygroyR7jaefqkeJmaHzlJ6SYC3qd56rPgL2Q
	OpQbg6ILMIHRxREnQzHN441BTaxewDMpxv2I5IFYWZDj4GDmsRaV3Q7JLGYPNaZKX6zyJtzrRyS
	bzgIWOCj+6m2Ps3SqFwSvBtDEn1bVAGRD6faKklcirg3V2yLD/FqED//x/A==
X-Received: by 2002:a17:902:f551:b0:2f0:2ba0:3b9a with SMTP id d9443c01a7336-2f03f1bfc54mr34636435ad.38.1795186715512;
        Fri, 20 Nov 2026 06:58:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f10c9casm15616035ad.52.2026.11.20.06.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	himanshu.madhani@oracle.com,
	ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Fri, 20 Nov 2026 23:58:29 +0900
Message-ID: <20261120145829.3127721-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
References: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
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

On Sat, Jul 25, 2026 at 05:49:39PM +0900, Yehyeong Lee wrote:
> Commit a47fa41381a0 ("scsi: target: Fix NULL dereference on XCOPY
> completion") guarded target_complete() against a NULL se_tpg_wwn, which the
> EXTENDED COPY worker hits because its global xcopy_pt_tpg carries no
> se_tpg_wwn.  target_complete() dereferences
> cmd->se_sess->se_tpg->se_tpg_wwn; that fix handled the innermost pointer.

This is superseded by v2:
  https://lore.kernel.org/all/20260725165818.769963-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
