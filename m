Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864477;
	b=U/jcm4DNxV0Uu0NMo7gXpQb1xOp6E1diNkOUrV5yl5MLdGoYwoxccis3TxugYLMRG73d
	 E8F0ea1XDcAB6O/Ayx9WJzepNVzq4xdnVX/iKgwdFiauXk9fBqhpTSSWa1GZ2qM3FRqHs
	 VXTw4bvnF0xZ9iJBGOOj6vb4KLHoqViYl3l312pHPH85i/7MzbOxG6KpsV3voy7/6ORhv
	 ghguK/0CRz5Jye9DwJE3RejqMKVhTiDtYgXKVNGX8PJnDO34Syq1AzI0zJh14xEQqzdHv
	 81N9L9q2TQeQpDoXacq2fTqEWcicB2yShni+57ynhHkUsDiFG3zK26cWJewd4eYuqbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
	b=wJdWn7PgrBv4Xan9fZil5tMmNHK3/LKCsNIPcFaImMfEzNHytv8fY1oZrRQ93MnQ3oP0
	 whYVYuTfGYjHLGF9DP2QneVJK7ocF29WdoHE9Dyg0fHKUx/d8UiGNPcJxSl0sYX5gX39A
	 iFr2QkcQMEZb6jvmpI4Xk8DMRvxKCtSLhQZjdw/i7PwXbrWPm964zUQPZdCl92ejntn41
	 7D2ID95gd474El/1Y2Gl9Wyr/odSe+BbJ6hQ+gTMzaYsZWWqfB/OvJaKhPe/mPjT3BjP0
	 FGgg/PlfsfqNAAiiyZsd9dDXnEmNKaI69Q8FXCUtyQsVSS/B31jXURrIQ1Vc16FaO6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FPpD0dIS;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48964606A333
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48964606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FPpD0dIS
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-490d59c3edaso194006f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864476; x=1795469276; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
        b=FPpD0dISyKSAsA/OfXo9aET02c5v7IUiKwrzM7OGBDFvjMvTZoNbDoYV4Ex3Y3uYhp
         Y6vCQ7xir6up1dfUVLJ23VAaalNZ4uISwqpeaXPNkJgGz301zcyyvNP+hYTj/McltQK2
         nHoILFZ40kLf7wxINR1Pp7egTSiFzWLEp0yKng4RRniW+DeMhQ4V0omBbBAyczu0GDB0
         pjCabrcA7S423UTuSJS/0gDXZklx8OB2tDXAufmuhZv6NgJh9UmOymUt4fRkyObYF2WD
         JPvPmLCEPG7sKQ2EBmwHpk+O5gd+zkO28V1bvTe+aAAB0Uos9QSDOxduGncYaIIXzqk2
         6qEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864476; x=1795469276;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
        b=0Wg9GOhU9jx7MazKl3gi+jkPUr94uM7dtxE/93zf/i/fIdVoynJvH8K4PxkOoF8ORw
         Gk3UxBnqVS8agX9d0Q4Vajdr9pTa9Vo9SvcOXe3eC8pystM12JSo4sYprPjsgL/BUAFD
         GPwXlJRnl0DjQ6QytM5pXohKzN1IY0NWvffUb2Y1jToA0vewV4aFyQSxwDYSUupkt2Ha
         14D9mXkcO99f5ncNuB+H6PotCe65gsTq5bzeeDWV19XDpKG67W6VpndrCZ80eXt4o+8d
         8/DUHwEyQdJXctTKYBRnuujWobNUh9tWXDfxIsrINsR4xAKtHBRTs/crlhpxCjMHvd97
         QAEw==
X-Forwarded-Encrypted: i=1; AL+hErGdEZzhgFWS1nnl8v+YrTllIJgrT3wJ8uXOFv11W/6E3J/ZPc7W/MSSVDuP+1/XRmNu8c3i+KWm1FnS@vger.kernel.org
X-Gm-Message-State: APuU4Z/r/aYRn8uVkwEL8YFOcfut91caDWOgvOVE+74M3ArAukTbusRK
	zu9lKpbUHpyRvps4smCIeyb/o/PacaZ5qIMoldYYIY4LJoTEp70+beyo
X-Gm-Gg: AZFdTZfWNTXhPAKIyyS8ZrJpFXtAmyS+BD7UlhEYC9Tl685OoW36xfnpdMFk4Wg8k0w
	Xis/if8RK5JAuXozyv1SDkrId1G4TUB2/E+I4lxqG0IhGUj4P3mVnDLMx88wGUhNjLolmCwXW08
	Ae2EUhUSDN44NQx9LzHXvc3UG0psdD4midjk9OIFziNKQ5ugKw170QsIg2+0j3KlSeWwoVEID+M
	hLbKWDnaOh6OO4tF4IA9wP1Rw+fWFEOP5h82RDBaq2cIuYWnoUpshp3SyGjD9Uaz0DlpTnFEjPe
	t2HDHQXlG61V0ybXYdzozbHEdf4Cm0pXMz4477vs4ZjlqUt7uw447N74KsIGRNE+EGTXhnFLl5z
	4Z6vHiZwIZ0gDG0fd48CZnEuOx7aVlXXCo2F3qXQTurZkw3vjEPs0Cy8qOl2jGeZ9tD5sseN08B
	bLsspbxYMbWdjdiyZD7gBa/Lk5F+VtZOx+LK4ui0nt8ulkx5072108GLUs+nkFt1SX1bX/SSIWa
	81SerteT8S4oIPZpTS4/b+bZf/k2Bnbn+zv32UQaz1dsCp4M6peDDeyjpnR9h9Mzn7G1hFL5cH/
	6Nbv28Vt3TP14HmLU6Kt3EaEvuxhr7iMmaB0Pp53WlUWN8t7+rO+v/lQ81C1lQ==
X-Received: by 2002:a05:6000:4706:b0:49d:8ce1:2652 with SMTP id ffacd0b85a97d-4a36bd51c5dmr1648244f8f.1.1794864475624;
        Mon, 16 Nov 2026 13:27:55 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:54 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:29 +0000
Subject: [PATCH v2 13/16] dt-bindings: arm: qcom,ids: Add SoC ID for
 SXR2250P
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
Message-Id: <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com>
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
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=746;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=wp4yEFlEeRirWebvDUNwJG87yvgwIo0fuTVgUjPIFVg=;
 b=c3M0oozAyWICul1zqZyYV4A722e/xl51QI136kZKSBBz/N4l9sptO65yuOtgNCZsSpOrbqAMq
 sRMLJj/ahy6AipZ7ofcwU1aakgIIwxaL8YroDdkKta3ZC/C45UuYvvM
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2) SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 include/dt-bindings/arm/qcom,ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/arm/qcom,ids.h b/include/dt-bindings/arm/qcom,ids.h
index 135297027580..cbcab632e01c 100644
--- a/include/dt-bindings/arm/qcom,ids.h
+++ b/include/dt-bindings/arm/qcom,ids.h
@@ -288,6 +288,7 @@
 #define QCOM_ID_SM7635			636
 #define QCOM_ID_SM6650			640
 #define QCOM_ID_SM6650P			641
+#define QCOM_ID_SXR2250P		649
 #define QCOM_ID_IPQ5321			650
 #define QCOM_ID_IPQ5424			651
 #define QCOM_ID_QCM6690			657

-- 
2.55.0

