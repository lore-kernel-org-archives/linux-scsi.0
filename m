Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864414;
	b=Dti5iuTesnwwLfufnEnO/+5dB+JxOTMDEKVUgSa8C+Nr5BH7xY1/xPHNk3ALhzU/Se6f
	 TsuX6kUOlRURw42m7WvBnJfO3laZbBRXeF5Zxk1+iAMbV1rTiQjfbf5h0VtCzAqL0Czop
	 L68d1NNHwHgdxm3YSnLnWFUEFOek9ILawyP4rThjM8X4O/zQRDFeAif+7LWOt/3NNKRhR
	 cm56a4jb357VZYi+J3G/OUWJxWldznnxtIRkn4bhEvUkEnXXTrnKYeFF6iOrCgaskcXEJ
	 pY+YTIfBnCJHZsf2XzeDzht4nEF74cs9ZQM55bb3VA/H0DPVzVFdyWUouLiy2pYSACw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
	b=uhauCESif4sLHeVxi40hLMAayZ0iNNyugCPo/sjHYMHJVMG1NWJtphgK/adQ07ehBlBP
	 hqSQrm0E83kztp7aqj5dgPwJSELSQcx3yQQJUanr/2s8WZe0+gVHGTY3ngq/7DPyAzty5
	 odETSY5Y0m9ZXX4k+HJXm5Ob6HwYbAw5Gpyhf0vAxkOlv4E2tmLjRHF/9eWHqzddpz8QZ
	 9YV58l+QDX56tcFfnX7p0H0jeIiBrWq/QzpLZGHsk0EgdDpnsM3RhDhnoLTLpt9kJqi3d
	 l+2MQ4FERlLfQOYU/Q0Zkvg9taT8sBv74pSABWH/xTO3E1HIXbpVE0ttzs26ezs31YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MAURpxwo;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF6606A330
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2BF6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MAURpxwo
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso45093975e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864412; x=1795469212; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=MAURpxwoicsksSVnc2WAsPB6JHUpT01pe/omkWv1cyD9LfvrkdfTpz9XI4PTsY+lD4
         SGrVtbMkILUcB8UlVxbff+5OGS2lWyRPg4+99wfZZJ3kK751LFxY/m8LTjr6oiMVus8k
         NLNpqxitTryKXQIbIcsKSMHDOxKylCzOFabOSB6t/1IlelEkuKnAU8DjjPvXU/qZDKLp
         LUS0foLTPneGc0r/9RGpT435PfWh/Tw1+g5u3NiaPw6KH3UroKGAVTBs+bDKLGIwpZ8n
         3wkffWoIIDLNuNqC9dnlPrAPuX1jUL9NxQr36U7VkPrRC2O736zzBd6z1/JXDHPc7i5T
         PENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864412; x=1795469212;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=v+GSISvhjg7qJ/nKsAFUcN5PsXGbqnDACnuOybaCZj4aGNueUzl3kFK5loCqJ+uTU7
         tuUxJGiPuoDtI+QPxT3MFrxcJLEJpMuWJWdG63AWMT2ldM/pthDiR3PfFijlwc9StdrP
         2G99gZyA5yYIizzdg953BeLq9pTeYpmgGgroGs1FDL0o+Ag96tKgDqZkzjgidV7KLsw7
         yt87kfvM6uNHaNIfvSTZl8rsCHfP2fy4eWdqaPp0uWHxwzNCAubIvGb+2Le5vOIAZVRy
         NiwpWGIR3ZIcFDhx47yNUkMD8KTOW0A0DbaAr98OxVZ9NUbAXfLmiB4BgeXbVsAqtp/0
         KWPA==
X-Forwarded-Encrypted: i=1; AL+hErHz/HCbGjWf2zjzhvAgVDI/s2owvv6hhds4h5xiFQCZ37JcZ/Ai2sCexweCoZ/eijUPXSnU7S8tLKJI@vger.kernel.org
X-Gm-Message-State: APuU4Z8UIcBvT9YkTidHblVZSmJf4NkwU5DjLilr2mTvXiZEnavZ47U3
	RTJnyop0PEegjChhALfdBhVucLvfGZrOtt9lDLoEGUjNQ9OXj6O1BZ16
X-Gm-Gg: AYBFou3Y/V85Leipj+arJpj47PfGPVEQZ7hDyApgwGPmI2DH9jT4qOg99yqk/CzoLX2
	YnkpFQoTOF17oM6xYODL+BWEF5696vDexjpL04ThDx4tqju1EY1qtC+TJTeDODkAajGRSLSu6wO
	R1DXZxa4dVciO1wCVO7JOEuFSUxBzXMndGtV4YmkVH4CndmYn0JzzM56epdUCaZp0YdQPt2oq10
	pe/9+QIQcZe73Ow4IpMctQj1PF/Z5Xxh1aYWYXAjMrI8CGybzTmr5MRIXfTLQhArAyorU8Y/dCP
	phSeMQ2eOMGsDEVGl6H9ZvuSSIU6pT8obUSK/mzJkwY397N+AFASBcj1imMytGW/bSlNKIVC5Fs
	P+kcEl/T9feOqGbCU0oGsm/wiOvwarOGuOHVo33ed2NLmInONDmj3cw73aCGoO/8pPLmE3phTCD
	I4mqa+2Cxy50ehhYja6AVxEpt6J9TPuDoVFOoyAnd09w+Zpigr8b/7Cr3ttyIYciuE3hI223YAL
	i/es6BdhqFJymoA0c7VLWFIbkwvpSWgQFXS2WNsAoDnOLRnRxk/dukxHZ7Xe4/XusUA9bmaser7
	V5mFGCdMnO7HStFRni8FNTr4I58XMV/DZSiiLhp7
X-Received: by 2002:a05:600c:3d92:b0:4ba:e7:ef3d with SMTP id 5b1f17b1804b1-4bb559f7044mr243891145e9.1.1794864412296;
        Mon, 16 Nov 2026 13:26:52 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:26:51 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:19 +0000
Subject: [PATCH v2 03/16] dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
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
Message-Id: <20261116-halliday-dts-v2-3-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
In-Reply-To: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=720;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=sz0jgm6yJ2qfmdfMMgsqR7Wg9ExS4UZymLewfvVCvH0=;
 b=FqcgSljUbrxAce/Wb8/tWQg7D8BxyY05VfRoM3lIlKWOtWcZxkvJ+EYJdvTvvxol8FPPRApKu
 mw5+dUw4O8RDXBA5aD2L3Fg9fYj7OF5FtJNOsGNYBuFx4Z8h2/2ns31
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the TCSR block on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
index a021e4dea486..e8a681b5e6ad 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
@@ -17,6 +17,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,halliday-tcsr
           - qcom,hawi-tcsr
           - qcom,maili-tcsr
           - qcom,msm8976-tcsr

-- 
2.55.0

