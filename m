Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214238;
	b=sk3VaWVoneVRDuF9TZDCXfv7wBNRlHY7VlxgSDP/OLvR1OfJM9tVutkp+FivhNiO0Zeu
	 jm0Jforo9/Md6KXN3hrVxskd3fdD7xICiRIo6EFB4alycAbrgiaba3YnVkFERK73CZNcU
	 B6Fon0gxwWkncenDuMNwah2rveB4+uewkojCrz41uYnhxOvURbuLV+4dGieancOm2f7c8
	 7lnZtnUKK/Eruc/H7iQaj0KCbP9U4pWwGfGn5HQtFS4ioyWqrUeQQlMAd1k6JDGAqNuz2
	 oY9aFIrmuu2zijj6BJV09QvO2A26VtzU1f1O4lgy6YbPwLc/h0FRB1OCpzkVLEAMo3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
	b=ttYehpWVb1soigKNK5c+9vL5FKel5AaXqWZDLyv92BJ5+/wr+OLizeyWfzdaI2z006FI
	 0iwaDiHHQdmgEhJQJBVl34Vin6z5WhgDITlSZGEn9cjm75ousnnzLs1SENo+OvY0t1XFm
	 hvaFG5PLghaOxoFb+CfVOmLeeCIhg5Oex7CR9WAvn+37rP0moda1dvzeiPWHnK9FT2unK
	 1lgGmYAkuX4jA+MnH9HBFzGlRycXCpN1wYQ3v3qmt5vJ7SehRORiSMHQCZKsnQAh5eaHl
	 9srwqXa4ZwNvHqj8/lVbLgtI+98lh84HlpY/ghqDaKVgQnAfYQIcyz7MNFg/wWzttdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGqde3Ho;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5968606A339
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 08:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5968606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGqde3Ho
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso4038065e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 00:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794214236; x=1794819036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
        b=TGqde3Hoeoi+P+P1MJHy6yFa7TDuVfP4g4ZGwX2ih4xjRGjRFWnypRzOP1Xa4L0IPm
         s/DPVbSTnEn6+vQabgyMvzXoPqHofh2/mImSCnYL5a12zXk5bVCjZsmkY8NnMPUi2SVc
         xAgwi/orvf9pFkFiAXO532yOUQEFgNvW8m3sxgUIowoBqxTIMXeJ2WTdj1dQHwKMPf0V
         cCNQoCDDyIF0nns6PDu+LZixogYHFd2CbQ0mtJSAP17FhsmRFJQnz4kJM2w5Emebd5cL
         Ug3ZqCYI9cMwu6iJ7WzAlyerv17zrvmPyC1IUPu31nRNXyg9pX/XYW5Pjf8n++ZvU2Ya
         pTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794214236; x=1794819036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vjj4rdSbpcMkkjnNoByhSOYk/2BEXBPon42q9R20zeY=;
        b=anSoXJPQUijcP2qtyDMjbcPfUhPwiVhYddA/smYTmIz+MwHh+hHRMfNsROdEZAyHCC
         k0yY8yNk6sDEPzl11hAjDTlCpfSWKXy6Egzzf2x+XSYOuw2aPbk0y04nkiuRtbRHFTiG
         ggZAJppKDrIqUPw3RbIiyBxkQ9SEo/DSvl00HpCkllDrODwxmhlnzCCSHVF2+Qc+TFHI
         MwWx6YcwD0xoF2fDPAMYDtHYyBQIcxC289vWjm8oUzTt1HBOkgsK7/7SmgvAVJvRofU0
         U9nBHA/TnyhQQ3LQlyYQ9dWbfp4DQkBNmHK0pryK56OdUUK6TlLXJKrSUeIgic/PpQAX
         RChQ==
X-Forwarded-Encrypted: i=1; AL+hErFISWFwQJxUFeGpJACue6x0mrOF4+qpjRgcywvNj6BdZaS5zGF01SZOV8gb4GLrxW5+4WH+FZzQnyd1@vger.kernel.org
X-Gm-Message-State: APuU4Z9TjuyjOrzrEnBbSA9LIaG8PXhm4oRHAnSSayrC9XmtkqSfIu37
	uUgjp831WwFJP28uCi7N1883QJ3R0xpMU1sRYTy3kdVU7tpHRxMGrPM+
X-Gm-Gg: AYBFou0ywwz3BMWZtVUbv7pSXAAB38llxJRnVltdTnKYBUcQ9Hf79+QG3r30vCqcX5n
	iZcIjUbJdhezEETN449mDhYwuMfXZ3kotyWhmAxCKM5m1w5snNf8z9gjX05zLqHAST6X+juApkC
	OoZ4nqU8UbZWBE7hSXcjS/D7aKWda+1Ld3SUfGBJclL9nm1fpM2Etu86+F/nxulUlsKpEEmrevh
	zVA8UQefzxWJGy1Z0PZrJj+txl9lHdjmm4EO/mZLMpmg6IRzb+cKrq7eH4T/wXKBUBp8frwZlXW
	dLmWZGOHWlZngvAnm1aSt10yCSG33fPITxPVyT4HyQYOvWchRc7fdkz9PzSjlVGH0F71PLrcJBq
	EUtHfarITvYQ+Ba50ULObixiNLALmKZ8M+sI2lxt++XhmQrL3tGh6BYXapfyg7riDY88XgBMNDj
	UCoOMNUr5Wsx+JjQ2glbctutqQpWAEzfjlin10d4+L5/h6t4c9hFAzs5gQM5ZwPtptj4r1ZTt1F
	RBqOnCjndxMdL6VWV/L6XSuIr3zqSFtyFNcRNVgAu5TDcEJXC02h7detRtuaq0sq8Xkj9z+7os+
	YBaAaYS+rUqYUwXIxqv7JnJwJQo=
X-Received: by 2002:a05:600c:3b1a:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4b963c7e496mr65389125e9.29.1794214235848;
        Mon, 09 Nov 2026 00:50:35 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b79502d5b1sm147015055e9.5.2026.11.09.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 00:50:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Lee Jones <lee@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
Date: Mon,  9 Nov 2026 08:50:19 +0000
Message-ID: <20261109085019.1751534-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9dbfc665-089c-45f7-bca2-74caee322885@kernel.org>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-16-289114ab8197@gmail.com> <9dbfc665-089c-45f7-bca2-74caee322885@kernel.org>
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

On 09/11/2026 09:29, Krzysztof Kozlowski wrote:
> Odd license, suggests you copied it.
>
> You should retain original copyrights as well.

The license is BSD-3-Clause because I used sm8550.dtsi as the template
for the node layout. The values come from Qualcomm's downstream
anorak.dtsi, which has no license or copyright header. v2 will add the
Linaro copyright from sm8550.dtsi. I'll fix the other comments in v2
too.

Stanislav
