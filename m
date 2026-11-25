Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578267;
	b=qmg4RA12Bn36bPhrnLGp6gNc53Thnx1mXwGaR/+86wBA+eoVktxzD9/siM4NTXcsSOZw
	 ZCOZwZ09uJpkFncas+1hNLxYWGkB1bgw8sxAxVnOYaO3fikyoOa2L3pwGHJnqDPmIClZs
	 914ACT2siTbVR9NY60fxMWXuULdOqthzzE6ale5cLkrrQFHZqFUcxzRCmBtLpB3pGxhoY
	 37GenLqWAVxPtUeY1OkRXM8ons6oJE16U2ghprBS9eaCJKY4o8a1yCyS7s3rXb4Vv4+zb
	 F69U+hqdaNnJUVHwmDrwvtR7H1X+4xLzv7I70TlK8tEMbTkW1xG/g089oN+Lionts5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
	b=Jg+USSJDmkKELAc/jx6jfZp11iWT8pXLXu1cw6SU8XlW7kFsaSGPrlEkckXRdD8FPh12
	 GqUa02J+W4BfHMd2QsiSGBurdcauMATyP/OHGLQQeXloGSowUUcJZogoMPT1pukv9EG24
	 7vFM+WO/Eiyl8dxNJx7wzMNHpF6k2lV/3BsqIcigFIqY3rX0EiVJg74LzabLoPwQgPasy
	 Z1+KPvx4z+se/I8jHBYX+TH8REUPTCgQR0S4yiJnRhPeYR0wJSWVXkWSMznAq5RcTXi++
	 O3M1MI03iaYi0N/zUMJKjhaCUHYRTaDN6Ojj22cmi+KaawgwSE8mBN497DqQ7HXWyUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SufE44Nf;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B810D606A323
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B810D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SufE44Nf
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so30184765e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578265; x=1796183065; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=SufE44Nf0iNE9uoja8l5aVwkLELQGBnnQSJnkwjjhyh+2xNjpXzsAoozPYmtygloR8
         XCTUXFjT3+t29S/3sDK7LcWZlA16n33y9wijZwHX6Ju80HJAddDGn4X7BJuoxGfZyLYj
         hkVfLXm4ntm+nwjdWfyzsw22laugJbD+VlTiUS51WFqjYW+ZG6kVM4gFIN/QsaW+Y1fC
         aAU1Ie+c77crPXv7rlxquXOEpdq5iUcbk9Bw/fQXVPCbH8V6mcT5VSFCrAHpkFwLMwqW
         r+ANRdiqb4fabO9ULg0rSB9NuToAJUGV4l4allUCaSpFyElERTRBJNdlXqDf8UMAlmtw
         OvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578265; x=1796183065;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=b+BuFztRZUntJuCMed+ggIVy/x1Rs4yXAvRUTQsR2PEn3WnqotSDCU5ss7P1vkzjoT
         AuKLPXq1aeM5Hxpx4KuE+3WVuORdlhoDWxW88zkE23ChNeY9jvErveg3BXDKxdnI2V+6
         41gu/fXUZOqSLW+etiRHdZR5pKmR4eaH+iZvk79IjMGSQ5+YOMX/5yPW9nan9J+sBCL8
         5OWixK83VM13WgOTBwkPiQ7XPPDYgjEDD18orgoOvRiyGX0SRooSsKvRxqKBQkBdKoNC
         tpQZGl45rJbS5roRhmsDA/8/5uY4rr9gQwKwe3d7xmmZHuoqcp39o6JVn4KO2hO0GL+J
         xVRw==
X-Forwarded-Encrypted: i=1; AL+hErGmly618SKEkMEJyzbzmQa2BXOQzWOxTJsYwuL2RLOaLIeoGRK6+B3HGI92cFyzNpZsVKXx2Azynm/W@vger.kernel.org
X-Gm-Message-State: APuU4Z9+OTv0KT71puoah5SWcSaJ5TvuZ2CIx52jrIPkwUtyJVjqcdXF
	BA4ALDum3pNhwfw2mEf+MLAZZvjmqxFPUYfNJSDAvC1C9AarhtbFctoC
X-Gm-Gg: AZFdTZdH7Jf+ALziwM1ispubc4HpQ0josGS/T0O7mG2E+X48c014KdKDRXBr61vGli1
	gSo+QFi9Xs1M9V4BVhoWWvPK0r+rN3xIFiY3pkxFkQK5LfmD2ra8tlo1LZCzSkgiUXLZ3KrdzQ/
	KZloDppOkDu62Og1vR0kLPa+0ud2Q2l2vv46DUBv+PMhzV4T52EyNwb6yYfkDc71eSNnBqvf5CI
	XFlWInTiUn8IwGFqypMDBnQ63wi/r3BO7uWUU/ePqhBDleyxWGDyG7t/Brvd3T/Duon6tRXBnxc
	b3UhzW9Q7P70qe8lPvKr/D/KH9c3BHGvPnSzamEP0PvXyks14VScz+F9cQrsRWB9DVvQyskRyTo
	s3MNa+Y1t6qulglNXxrTgZyeZNhd5p9sX63H6++0trn0oL/tvGookYPF/lScSd1ddugNqPscBcM
	9nH0Mz+Gfg04MabWOlpkaMdSN3t9M29pR2F565jnIfsclKZrmIZ80DsHf8wklO8cWS97ktgCmBH
	YKI2EVb2Sn6lm7a06+vLgSJzZNTO8Q/awT0i1a7B0apjuxZvch1UtzZWs0PY3pLtNKaAySj8LUa
	MabsP2LvqeJVi2/AYnD4luQylFXSh/tU3I9qgKM=
X-Received: by 2002:a05:600c:670b:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4bb88922df3mr314413945e9.12.1795578265228;
        Tue, 24 Nov 2026 19:44:25 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:24 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:06 +0000
Subject: [PATCH v3 10/14] dt-bindings: firmware: qcom,scm: Document
 Halliday SCM
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
Message-Id: <20261125-halliday-dts-v3-10-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1106;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=OQO+LwEeY64jVYcmV4r5bBUUpcSQt6/n4JPVT4Z/sxw=;
 b=ASSSZ1iPRbCJcDXI+svsrzgQJoNbt/i5IYWaxMLqGZRF5nHWw5kJhARXjldkVDjeYGCb2JyQL
 2OZ0LHRj/DeD6xQR3UFBtL7exxUKJQpjnA5HrXZmN3rAlw9HlvDVkc9
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SCM on the Qualcomm Halliday SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
index 40a267c54b00..fb3da66443ed 100644
--- a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
+++ b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,scm-apq8084
           - qcom,scm-eliza
           - qcom,scm-glymur
+          - qcom,scm-halliday
           - qcom,scm-hawi
           - qcom,scm-ipq4019
           - qcom,scm-ipq5018
@@ -225,6 +226,7 @@ allOf:
             contains:
               enum:
                 - qcom,scm-eliza
+                - qcom,scm-halliday
                 - qcom,scm-hawi
                 - qcom,scm-kaanapali
                 - qcom,scm-maili

-- 
2.55.0

