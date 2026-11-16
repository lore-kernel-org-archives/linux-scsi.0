Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863223;
	b=yWOXHtZni7uc6MmIBL/izzX3guo/i//QfN3xlCNZgeViZvaYmAdlVhKv0I5Jn67NX23I
	 ttdNpsNg486W4ZSycbi4CCsJAcdue2p858b3+5Ng6UiDrk7twRvOANQPY/E6Vb85q5uWq
	 dimk91JGoLK+8Xkt3/Cta7WywUH8PR/nOlu8a6PujAXx64T+Hnmf8duMcSMs7kIoJ6Wdr
	 He14TdUiLkS1bTSKKS4pqfXOi3YG6qcRGvm1frfwpF66IoxicNN9R7GV6VRClRuKfdrfe
	 p1+D9CUdNxJVZ/XnwTa7PD8GMTJhEYoGyHelzzvahBw++fLyOaBCJrK6lJyGaedlrlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863223;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=iVDxhts98VbGaLTKoWza7C2upNlIZZcfiRD3PUjGVr0=;
	b=wPnEx+m4i25KZD9tkaQloTkyf8EyMxc6gc5ogaYZqDbK0534/dkMtee7t/oB78A4nhLR
	 gJTlzOl4t1GDtUJh8kT8BAebHccUH+O9Zckm2rMM1JhsCyQU5oM7XLpk13C4xCk4eaZL1
	 hHDA0/erzmpykNHtEbipPTY33l+GPKinACY5zPFJ9mOaDebgsuuiX/rrhuzd0YJ3ojrKO
	 t8YbDKI9cBSusn42q6LPL3NpukSDfsqwsLu211ZKof54zU2mdBtZh6+KxJANpNvce7fX+
	 fkzn3urBZ6sQdj/6dfgVVkwn9gx7pkio+iExkA5MEmck+T0BV2vReSznGqzzJ/RmewQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FDMSQ0LD;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=WuUp1IoF;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05823606A31C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:07:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05823606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=FDMSQ0LD;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=WuUp1IoF
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXNoU3638129
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=iVDxhts98VbGaLTKoWza7C2upN
	lIZZcfiRD3PUjGVr0=; b=FDMSQ0LD+Y5wvj8RLo0FKIv6XIDs9U1xDwiABFg9/q
	4aFQvqTOwNPTOi1aT1k0o45Jzur8I5BGwPKwE2ic2BUShev6ehKHtHszcYV/nstY
	8etSptv4/4nMKM3N2NrNWGwEM9dJHJP5LiXBeMzdRa42pKQcJDkTSPOa+v8ISqyr
	fGJae0M16fqbzkZwbaaG0sv1YG5hxOgch0rkoMccYsIEvVpdcg3gIr98IgbJiIkn
	ZZrxijk8MpN6KSHc01g/4YbdHGAHZMeX+dudY312n3sL7xVJNP+ymBnzscjuhf2Z
	hzbbNM5+ah3Al5LmhkUC/eaMFSpV2yQAYR28nggU5ITQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059cjqcq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:07:01 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9495dd0f07eso667547385a.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794863220; x=1795468020; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iVDxhts98VbGaLTKoWza7C2upNlIZZcfiRD3PUjGVr0=;
        b=WuUp1IoFZ4DJXFoxyKkdms6iotlhbBuoEx8AHqsrdFlHm7I3TIN4pMTfdqw9ysldgz
         R9lJ1t+CC/IVy9/oNdfsAfabv4WXVN67Ypsq7xWBLQcCwb8l+PUGz3QG/IGWaCJgGDIn
         xcp9nYVg7hzqGJKeQDEh5sQ9/HBZNBrZs9zk9BqqmC95ymPb59Q0CCMXX+8VoPwSwbZe
         CeBh6cwjNqD3TpfzHiMtWACL1dwuaFQIjJ3I2ad+GK5kMdp+saZLhNGtV2Mx750ZEmCF
         bigMY3dS9UdZHeOsI/kAWoSmnrBXwzlVxhT4XSooYi/ze54/0Xhm7FBWL8dRY0coaG7w
         LqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794863220; x=1795468020;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iVDxhts98VbGaLTKoWza7C2upNlIZZcfiRD3PUjGVr0=;
        b=RcPJRnT0brhvUB1cm2XPUymdIbdRse9Vy+l3OcsceDk3tgIV4g9Gha8HpShfMEm+C1
         KTO1urgfjm5mJa3J7ZeiQ1ablwNbNaDeCdQpmDNs+UmuTu6CKyVJJWONWoO+Vvx3R20C
         fy4JPxDMENNZa6XFje5Z2yvXX8lNBlxD5BG7VMjavljJgnoswntyMQgV+NwTfJOT2Var
         i1TAHhsl8Zc6pnX7DYGutlO+H9wPpuLGTI5/nA7jUhZgWiqyS77HEpPtYD4AD6ARdRct
         /uQ3Rla8EPkSbB1BRjryUZpaDKZrWki/vHHV+HxwNBpAxUmNvLTAayZj5B4pEcik9dnq
         M1Og==
X-Gm-Message-State: APuU4Z/VG4GFNRrFLM+6o99PyJClnWoMdcYfJXW3rRtqQJa7cnaibHY5
	O88g/FdvKIcmBIUx8h3obtWSsXx2UT4ILeuKn+sciuxH6wIPbmjduirrZ+ngP0elECaK/bTNs+m
	gf1P0/EUHnfE4lsBGGfD8gUykVZTB4VEgj+BoIhD2DyTG/z0E7XCbL7g1thg=
X-Gm-Gg: AYBFou1xDS2mFX3mSUIj9VVLYCZfjIelQrScbPsVhLSo5Gbmx5/vKNAaKtCYEK4Bq0Y
	9cQVx5L6TJBoxbsQVEIzjEsdaSaxl0ZrVRbOatNiw7qjvNUVw/AzyseN3CSiAh2bO/DfbrbPPml
	jv/hHv38V1L4fkViYEqT8D9ddc150al10X8RRV8IYdlD3RkpnYeO81Yo51MDw6QG5fco8FWOImS
	ljwgb35Rf/ZZZ3MOeZJcIDGkmgboj1KgBRfAmL8CXRtKCsKgo/r0A/iMMJMogS+bltSdBqnX45/
	38BDObK23wzHjn+iMLSyuevg6GzxFAWQpLCppMZsL9gqwA9WVGLWt+hYB8zQDSLLilMrUt1kyuG
	Y5jRZ0SdEfUCdHbmq3dWoDu4D8V7/qyqYm1IBGHh7MmwZTp8GDn5cgw20z2e1GNKqvkP0m0oFKc
	UdlMkOndJ0VBntrAdaTk0W
X-Received: by 2002:a05:620a:4693:b0:949:6e15:e1db with SMTP id af79cd13be357-9498b875f48mr140905485a.73.1794863220252;
        Mon, 16 Nov 2026 13:07:00 -0800 (PST)
X-Received: by 2002:a05:620a:4693:b0:949:6e15:e1db with SMTP id af79cd13be357-9498b875f48mr140902885a.73.1794863219873;
        Mon, 16 Nov 2026 13:06:59 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949689e4e9bsm629661685a.17.2026.11.16.13.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:06:59 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/2] scsi: scsi_debug: fix zone reset with virtual_gb
 and DIX
Date: Mon, 16 Nov 2026 16:06:52 -0500
Message-Id: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGxw+2oC/3WNQQ6CMBBFr0K6dkzbgIIr72FY0HaAMUpNpyUq4
 e4CunX5kv/fmwRjIGRxyiYRcCQmPyygd5mwfTN0COQWFlrqg1KyArZM4NCkDt5+QAjIGEHlrS3
 Ko61cXojl+wjY0nPzXuovczJXtHGVrYueOPrw2sKjWne/hpJ/GqMCCbq0plJlbgpsztbf0t1Qs
 0eXRD3P8wf/B+EizwAAAA==
X-Change-ID: 20261109-scsi-debug-zone-reset-14fc587c9d45
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794863218; l=1274;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=EVbVloU5JgoABmKS+qHnRkr8QO76vzr4B/4YSXIMxBU=;
 b=nSOnE73IYUXvryoiy8erkG4y7Ir0srTUWsASOWXfHQ44Je5KJZ4echUqVi0oeOV7ZgAIfxeYd
 dcLCTQgMFowD11DZL9B1t5jFPY6kCuXohBQ/LlGdk8FQ7IdP7UBlHRR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX5S5ktn0sTBvz
 FVCVVcL8hj/u4YZnb0b+9NlGGBw7ji2lmQM+Xh9xfHaqE/tZPEUG2NVQw3q5HZ7mRYmrkO3SyYL
 zIubNlI9aQ7PMGKGt1DGi5GZ9aUG0GX9i1wXG3L5KasUyf8vFNuD
X-Authority-Analysis: v=2.4 cv=MsPHeGae c=1 sm=1 tr=0 ts=6afb7075 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=bC-a23v3AAAA:8 a=Ft1lhZKXRp7ab7J6uJ8A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: ejQ8ss0pwtq8QwNvGMZS14yPrrFIiJO9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MyBTYWx0ZWRfX3TQXAG5Zdq6d
 /dvIB1cTh2JWYsQ93MruOgfMhmWmQtwJsprzoDQ1vAKc+KAIxMBUk5nh0Jh0/dY14TZ2Vx+jv7u
 SGXt63P/jvMRjzuKVN5wWH3Nb+CHeFVYifznXMn8yaacx5nOP9Wnn3AIHQ/iTq5NfVv94UpNcGV
 pW+XiFLrwKN9UrJX1ozfabttAAPWBOpXoWgJZ6zMlMvjGqKzRN3L/yL7Kx3GJXOloEMpBO2XQyh
 hBnvukIewoVps+xKuoY9qcfEruC7F8yTPm0tWbJ5QFxy+7f0m+/wkkB0iL2VbPVWkq7wYPnBhjK
 mGjFQxLr0ytnNV9HFSlR5lEEdfij8ZT1uU18LHPpokPJnUh5SBWuknAbOViO2MNPkkNwP32Iz4a
 G0JkB5Vz52+CkwfFGPi5Yxy2fcbOuu4Jt3RZgKzwJfNAb0CuXUPoBBJv2ZHGvDuGaKorG81nmxm
 w2l/69R3bfcuYO+1DsA==
X-Proofpoint-ORIG-GUID: ejQ8ss0pwtq8QwNvGMZS14yPrrFIiJO9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=10 clxscore=1015 impostorscore=10
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160083

Resetting a written zone on scsi_debug zeroes the zone's blocks in the
store, but does so with a raw offset that doesn't wrap around the store
like writes do, and without resetting the blocks' protection
information. With virtual_gb set, resetting a zone that starts past the
end of the store oopses. With DIX enabled, a reset zone can't be read
back. The first patch makes the reset wrap around the end of the store
like writes do. The second resets the protection information of the
zeroed blocks.

The fixes were proposed by an LLM.

---
Changes in v2:
- Zero the at most two ranges with two memset() calls rather than a
  loop, per Damien
- Point the Fixes tags to 2d62253eb1b6, per Sashiko
- Link to v1: https://patch.msgid.link/20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu

---
Tal Zussman (2):
      scsi: scsi_debug: wrap around the store when zeroing a reset zone
      scsi: scsi_debug: reset protection information on zone reset

 drivers/scsi/scsi_debug.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261109-scsi-debug-zone-reset-14fc587c9d45

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

