Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864484;
	b=mRHjDSoGcb2h1gy1x/0jzvyhbgugQpaOmF/xlesm/HqM1rN1XTHXbmzn5uJb2G/APzS8
	 nrx9Sgd24WBEGei3Lw6ks0ZsmAn3eUyqk4Wx0btdliqw5aBR45het153mYP8+h/meTMza
	 UnYjYyemxDRQWfccLp3d+zWtKXUNNWX9eHys9FHS0uPh2ycFBcCTkeSaVFSZI1G0XAFNB
	 el+iJg7XNsvGsNogEYygxhkXPrm1Gzs/KW1LSFHN8zy0qGfb9JnpUQ5YnBX3ncbFnCPmT
	 Mc5Kngxg3cvDQVWy2pCtLFLoa1gpmqDCdyQmCcADmFmpYQrDqEuRJl1dqJohtQz+GAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
	b=izzoZzmxDszpffrayf9bFvYns0F2iNRTB/PulNx3fj/RPs45Fk2h5SGErb7PxdrsfyeA
	 aL7fiY0Fh8FIDqO9d+D8yJORhnSD3XLr/aVqOmgxhJaQ9nl1d1L0ofAqB7BbsiFkVfMdj
	 FOBiAf/dRWfNktz8ZkVAArWI0JLmlfURpZL7UdRhFfbi/Zi9gX5+pCjuPoBkH0O4OV2MN
	 KTr6t2ohVmEmTNlhpbjHEUc9VFFGcmqtdttzFYgoZ0HNfzTD6shXCkSBA59U3xNlacKbZ
	 tar8UymxbI+90fY62V21Mi6nM9/t4d9adfV3H+6AdhZqeCFSF77p3baw+c3KZC8vXXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UGH3kEag;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8968606A886
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8968606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UGH3kEag
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso4246493f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864482; x=1795469282; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
        b=UGH3kEag7+QnSPw8NgN0my144BL9MI6P+lzS4lSmWpGQLU/I1Wj2jG9zLis6cKkcyN
         ttu90mcZBjnspWeaKA1sIRwB9cdXaff25bi0pIzo2nlZOYJTE5UudY0yiqgN+oIc1Gk4
         27gWEvQJDPseqUIJdZV/bKhN6eyFQZ7udD/C2KLm+okaF7uw60hj4NRq7HAVpwg467V9
         MmOa42/K0JqbfZnd737Yd7PfrKLwppbtes0cyHasCRpOwm/EKfvIwi9YyvfmdII+iysG
         TW0GSAVvcD/jtsTLZMB/5KuH/HSlooTeqSEMLMXw4y/dOpM0oYUhyTRXoRWTIM99mqwk
         kqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864482; x=1795469282;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
        b=AfcIjyn3YMw5HXvzLWaQHnMwW7LBAoGWrA9T1EPQNL+MVkJqrmKBLVGD86HyX7o/oY
         R6gyFXvbiJsVqNmLf2Mu9Vv/T9DCnZBfPsO7SCwf5X2Zhz+qwPsWOisSEMPU9XfdkdmQ
         Gibw+kXEhmqcayHpJfJw27j5/4jzcbmlCz5r6yaqhsKHDekSgBVboVG9451aDl3HQO2N
         MZlw6Y7w+ulgZkdk/zzwPPVp3Nhj2SbFilJZMPrFUm1Mt0Am0x/J30dww6zwiKllzWq5
         0Zj5JMPUWW3+OmsFUn2feuiiwYXs2aRRr2CGv2kPCNW70xUGipEeuBu0AQNVY8XX+g7F
         2ecg==
X-Forwarded-Encrypted: i=1; AL+hErFnitFuqmA+fp/KUPwscDd9VEG21pdfCrrJd1L6x2pvKhB8akiNZPDmT0DvlObKoVYPikP0lgYyEb7C@vger.kernel.org
X-Gm-Message-State: APuU4Z/sIeM+YDlyZ0iHYLI/byoKsSwiiMCf2Acc8urwe108alrlDJoX
	aWD4cvMZIN14flv3NB+9TM6BcimY5pGh/2h8Mt7LnVTfENBT+pZrQaci
X-Gm-Gg: AZFdTZeZrg6Q5NVPZNSY+Jyrz0a2lEW8AuyZT9MbanKjfR6LZcAsgZtx5wuuwmq7M6Z
	lkj/7SVtrtJyVpu5FG8aP3fe1r3LgGUv3x3QEv7ahHskERu1udQY25WP0UEV/vHTnKl7/ouiA0F
	/4YTHSgdzvwhACQ3MMPwioEayxsDgEAL4WUAdBHZurpw5+DqRetEK1FhEVwNL8e3U1YHOZyN+Ym
	UIZy7+OYTn4GStaYz3QgG/xpQQlsuCuXw+naeYyhvP+732T90/HIHJ9tBbGSiieT1myYj5B1GoV
	2Q6r/gcTsiC5ZGD/TL8KmI9CkBDyE67XXaa4hAx3dzGwKDE+vP2Ti2cDfj/+W7AIjURr8DZqahy
	0glsKI0/l/uhHQgJP5fR9PbvdGHiJwvNH8auGNFY73Nl5lcU6SG1XWNn2NfUn/q1JpnJmIC4hBU
	D4j4jGxHUcuNcZxprg3jttsvybuH222kKyI8fz1cvdsgI+x18UpcLZVVa374IfVsFye6Unxq3Ad
	4Nv3f2vfco5SrRlj1AY/Rs9P32EnER25oQz/TPaL9be8QfzH7820uJeEAaVjUYsPKfeQ21wp2BU
	FWFhX0axbvDql/Ya4Z/26ywup+IF1g2b4XXwYJ0f
X-Received: by 2002:a05:6000:5c7:b0:48d:f996:1814 with SMTP id ffacd0b85a97d-49c7325b40amr23107019f8f.57.1794864482125;
        Mon, 16 Nov 2026 13:28:02 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:28:00 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:30 +0000
Subject: [PATCH v2 14/16] soc: qcom: socinfo: Add SXR2250P SoC ID
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
Message-Id: <20261116-halliday-dts-v2-14-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=679;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=6bC47xmeKrVS8XaUkfpVIXGQqamVpsrDydmAXACmpko=;
 b=L3bECMGWqB70KSAXliPLAtrm9JvwyHz3xUlIS/JSaVuyDRybXKh4TJZIKniI807WZa1pL3+Ja
 bm5mXrDXMYUCX9Qe7poGqRt5BD+3P/4++4UczCRJAuB1UHs6hFIK/pI
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the SoC ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2).

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 38efc5db7fa8..c5b61d28fc9d 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -529,6 +529,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(SM7635) },
 	{ qcom_board_id(SM6650) },
 	{ qcom_board_id(SM6650P) },
+	{ qcom_board_id(SXR2250P) },
 	{ qcom_board_id(IPQ5321) },
 	{ qcom_board_id(IPQ5424) },
 	{ qcom_board_id(QCM6690) },

-- 
2.55.0

