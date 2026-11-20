Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186799;
	b=E7Aqchii8eY1uinUKy+TXDzGip4Moy5sQYgrtW6zkQMR8QsF8FEa9Z8esR7vtS9YIFf/
	 rGcjkO149PPAXF+CUDFA63MAFtFXmlW/VH1tz6NrtLkSq+b6aVD606+ByzNENQ2RWAG8a
	 sVdoa3FqP5vKe+zJZzLVCXr54r9jcGr+SrWOpREozKB8l6H6g3TbWY+v9QIqt8RX0uK05
	 yrheSoXzAEj51bm1tqzH5wGqk/7MrBSJq2g5DCSgHddqYu6l9OJuHMZHGBvnmk+rGOr77
	 JNkHWguX3/Hx8adVryzJuxoCRD2/0mbpAOPk46MZ8A+Exf7I0a7ox7BEegyN385ZDww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3+f9Iofbt9YZyUypCVZ6RFlr9irdHyVfSoYR3Rdd4iQ=;
	b=fxYdSOFi3ZiFaIiTvrKne/qkvfvYppqc2A3+6sXquNi4mSYHW3JoM7jJuLekPfWsFmmi
	 rRZLozVSmJKHmCrRYfZ9Md+mgUs/9cga6FlzCVV/e5uAvNc1MueujlNVpO5J1x0ngL0B3
	 izeigzxyhUSDggDERGhNGSE+Z4/mnwPCKzwar/u0ZgUnkItSi8ex+XdEpQduAd0Hgkebr
	 5WUk5nOBbdeHehlvx/f0lwcRZvEg/8uWhLp4jHVd4TqgIe4moyMin9bRp928s5NFf6IYw
	 6cTTnViN0Mmn/IzuZFYBdKHJ7JGjuKYRNIH2qU0bV6vCSDYrCJKQr1tB/17cQb05xQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rFPzvjoW;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3BC60A3832
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D3BC60A3832
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rFPzvjoW
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b413d04c93so673024a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186799; x=1795791599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3+f9Iofbt9YZyUypCVZ6RFlr9irdHyVfSoYR3Rdd4iQ=;
        b=rFPzvjoWgEvgp82ZI7gF8a6ocv/SWxZUewMOgJqKRlwedKjOK3wL1McP1H+7YBy93C
         owhen8LODMg8gWET2tNCwIhq3J23Adp1NUaq0FbWKHxmw0ADnQ1fNiY/P9UPXbdCaN5r
         xK3TRIiDNNwgvF+HZIw9r0wE0pXJLkkfkQMWAnN77ztTunwyabTq5U0Upt+O5MTFukKV
         lJGHSpO2e0vqLpttOazx2VDBvjkqIpd23BUiy8LKTAq3/bcAW5r3M8B3CY8o/mjsLsMy
         KldXsmEIBNDURHeRwJsWvqaZU2V9EFVq3PVqwSyI5h1o3UUyNr51iTbxEhKo5RGZ/HoU
         GZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186799; x=1795791599;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+f9Iofbt9YZyUypCVZ6RFlr9irdHyVfSoYR3Rdd4iQ=;
        b=zeiRWi0zfnSo+X3gr0fVu3kG+yLhLNqLhGtIGqGWEj5tOGKFd6syTAed3rmfs97anZ
         knekFSNvlzicQbmQOL7YUGBWdsCzHmDJo/R32NDi45Bvxb/qNI/qCRGX6NPPRg3yLSSl
         aEzJjEaiv+MeLzI+Zsdldd7UHimTP0b+3sLpwdU84fv0r29myqtjMajrLDjzBVEC9UYn
         wC6C49VwF8DoEZUKnsjyY1cGb36N5UE6d8Zxq8Zn6gBnwJSTS6UqPuaRnNzJLSjMDclQ
         Y0IF7PbtZm/fh6oJcxzU1P+BR2CEqD/RPKSeRsfHct+uGx+kvbJ/+1bAyv+04oM0+912
         sb7w==
X-Forwarded-Encrypted: i=1; AL+hErHZTTc2eoFIDunBqUgqGHEXkuRjc569YaFchTm0AsmECOQvcWY+4S969aP0/1wvGe2/kSfHYN3rmNfl@vger.kernel.org
X-Gm-Message-State: APuU4Z/J3S7eV3KHqi+/HwfW35bvaDNfZnj/5E+8QvKKFfsCUnrRfMpY
	sn3XnTTmBorFCuoLqqCCjBibMjXo44wFit3zAWzh4qypb+p2+Jo7Whs1hSzLML9eqRY=
X-Gm-Gg: AZFdTZf0PzEtK4N1/jayQpJ4mkpPdTmJNSCzS7+emb8lNZvMrlo78roTq21oMuK05h/
	PDnVhefb5skfXPy0VDFCcDHa/L3XfQ7w+jWwkDo75FCvUvyCbWsoz7UwanJDmGfd7mDr1wxf72I
	3qiV/0k5xsvrnR+1+eyhPg1KUgS56bZhxM3qaHMTQ2OEfoEKuoQEJfQ6Jy/bjBNl6dzinyZAW5T
	rVo93X7O+xZ3qzw6lnSSIWiT7+Qc3v8nkvVM1q2+hoppgBXHD2y7fip+UT1sN4k9x1p10kjUBmr
	aqbPYCpyP49H0TWYb5uBXGH8CtpQ2RsQ4R4tsEKtxNqCbxWEnza2wkVL7DooNJi7x+Qk8lMs7dt
	Y//wsHt47l6a9cqlM+mGhwkkzHm7hrtKZuYAtq4TWYlEbz+DOhh2KVihMwmdwEQa/vzxloLb6Pb
	LWd135Pc1a9/Jf9CtKO5zam0PlTjo9TIq49CKCE83mIgOBLPfTRmlDazmNalbHno2tFsNZUGl4A
	6qNVxFdjpR9vkwbJHZa/t1EbzC2yCmquKu1ntjQ8yT6JfVsM+FyiYJd0JlfxgHCemj9d3zkizGb
	opWcSNNRRj3nh/fzLosEDcGYDbOC1urUg0amk46Iqg4lCNqmRHFL2IjmRPkBLnCTiFH/ldDnajL
	DJCo/jW4wgQUzHmO5Ix4Z6mIt5GwqrfbdOK1x
X-Received: by 2002:a17:90a:e70c:b0:3ac:aa8d:19ee with SMTP id 98e67ed59e1d1-3b41cafd533mr3117737a91.38.1795186799140;
        Fri, 20 Nov 2026 06:59:59 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecbd0bsm7782207a91.15.2026.11.20.06.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:58 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: aacraid@microsemi.com
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: aacraid: bound adapter-declared sense lengths
Date: Fri, 20 Nov 2026 23:59:54 +0900
Message-ID: <20261120145954.3127991-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Oct 13, 2026 at 11:02:12PM +0900, Yehyeong Lee wrote:
> Two spots in aacraid size a sense-data copy by the destination buffer
> (SCSI_SENSE_BUFFERSIZE) rather than the source array, so an adapter that
> over-reports its sense length makes the copy read past the source and
> hand the trailing bytes -- the previous request's scatter-gather list
> in the shared FIB area -- to user space.  Bound each copy at the source
> array size, as the container sense paths already do.

This is superseded by v2:
  https://lore.kernel.org/all/20261013150420.3168223-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
