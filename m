Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915535;
	b=WUmPIoqYFeTDKEZ/FiNXaD2gr7+AS8UD0CzMa3nrNwJW9kHPNNi7DPOZ9srT8qKuwAj+
	 44Uf27FOswvMFZ4mcts5wU+2aIF5PFwBZO6KG/yKQLaZw75dzVb4wKt7ZARzjtVuqpcEt
	 AgOwTnvzLpY+6QzTaSbZZTfTXLShgbFm13yVL3Rwho2rBuPSjwys5IM/wEx078rHYn6Te
	 0HWSu8GhyI6k1Z2LfAnMEPDipMRYv6ir6S6jK9ZsTQUXSUNdYS3E6kjof4cm9lTf1gHF8
	 zBv+i4H2DTdzqe8P3HsULWaQmx4ggykEqM2UX52vP7C2iX0E8UsCEQs7xyrGUs2ppyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915535;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=f5e+r6C+Y+boKKU1c+tSb6Bf3yIjeJVK+Xx6iJaNfGA=;
	b=O88QlE0W/tRVhlIFybcitZrXutbA0h1VSqgyW02KYVfWY39bSCoiz7apqD4CpewOmHJO
	 nO4MNxtmZ90M09t83fTh3IQ9A0Tclys2OuV5VUBBCslcY/39GLQzYzpZS/D4rxqb94FuT
	 IbVMbX0nmAmEwXDrl1Os68Xl5ixHTeRAyrCczFvHFS7/AS6Lc0PQbMDfN5ZOtb3q5TtF/
	 IM/6qHAkf5szqnhHql0FfQ6oqs9UDgS9mZ4AGtLGcQ3PBzkPu7M0mqcLv01Oe3WyVDwzN
	 j8OAQarFDBLQQTXoV8/wPJxAAKheZuVVWIZHHakuXAzltxCKUcackNatm57sOYZr65Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=andrewgigena.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC11B606A33D
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 21:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC11B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=andrewgigena.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be42ae8eadso7368e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 13:52:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915533; x=1794520333;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f5e+r6C+Y+boKKU1c+tSb6Bf3yIjeJVK+Xx6iJaNfGA=;
        b=iajmTsdoDmXB0tDBV0vYzgccd67cy2QAMMhrIYI7nSOCRDWb9etmGlgpUKVOuxvWZX
         9iDn4rTG4rHNmpO2icyHCpQnX0saOvsxJMyd7mkYR7nQ+OSC1hyVtycrtjk4nSp6UtRB
         JyvWGHxdCtcKM54+f0QWOAvxmYPrbUCXeKFiqs5QUkJhQDv9YrXwlyiK1KVQPnwpYQ4N
         7K3vsVvRZHLjsvrYkdIaX6CJvUb/gQ+kt9Ift0XTuJRawRDA0VDsXLVIrkR0WIaxzpOk
         V8aVm5HSrPQriCHwirvDlzaxhUeynhA4g24wMVHoPqNsee5pDxaCI5hE2qR3SP6kiyqD
         cTxw==
X-Forwarded-Encrypted: i=1; AKwUvBxlc1K5icWpGHUeytzGmMW9CyEp8Vo7X5d4T5YtnnJaKn9y3abi0ctyEymWkY6FWPBZCv4+tLG53DM3@vger.kernel.org
X-Gm-Message-State: APuU4Z/eIFchAHcTSak3NHXpPmOhsUFrewDlyAeY/we0oosCMqCAyFep
	g882y0SFteex67hFXfyBkJ+VsnBF6EZ0SaHg33ZKSoovW9HiJuLH1mHelcNvi40K5I5Ceg==
X-Gm-Gg: AYBFou3LfpQS4GGpVTNvxRrvw1ToBeZeWSD/vJDJvu6qUNqmWPURfaBnAD9fg/aztcA
	NIhyvcvf1fqF7FkBwnHIBxwEPKxe4YpqT1Rt7I9J3M1WHP3oiKvwZf+z0g2pfe2JXKRbGlLdTR7
	WGNb8NDggNY7Eiy9Dls2xAJGdtM7gpBq0VgXhZUJhHymSKVtEB6LhvbfS0DhXnlu/4r9raZfhzB
	lGg+rzvAKNaJMKS947IbCx8FeaErYMZSgUxGxkS+OuOLC1zbOiZrd9LxTObPDfK8bjR18CkkPup
	uGqQWfLMjfVSE0XsTLWlMI96zPxhedavfxoBbv6wJzdPQeCbqBLZTGqxPF7YWJdXgwiUM6S6vJG
	6QNLY6auLu2skAYj/nYV4u7Ql0OTMLrkP8KofNF6qZYHSysniXNreyOIWvQenVKintUkpQB6CW0
	UA6lvsAvCtjH/yQvHFB4NmDHPcHMGK2Z2VzT8/c0PxUVPzC9ZaDqqJoqnoNltpLmfrTGGJ/RBeg
	LZcuDJ0tjaKGPYNHqRiuAI4QsWR1ZOhZL/74vzzHZ7uBOm25i31uEz7QCRHEmklmeMmUerOZEWa
	SCZ9Q45ovh76mI3O5IOS2Sh9oggDz+EK2ocWH3/V5FR/yrJGNYVwOMUrQc8fLbEd6CbQEei0
X-Received: by 2002:a05:6512:2524:b0:5bf:a363:3392 with SMTP id 2adb3069b0e04-5c0037c305cmr128239e87.2.1793915533019;
        Thu, 05 Nov 2026 13:52:13 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c0030aa956sm67091e87.83.2026.11.05.13.52.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:52:12 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3acd304b5fbso18645011fa.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 13:52:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwBYB9FGfxqNyVczMpbBGOoGWckEJCl+k7FFZXS/RZJzeprkxjBAdze8bEMQ0FR3Unmj8vmeyEqj1jp@vger.kernel.org
X-Received: by 2002:a05:651c:a14c:b0:3ac:ddd9:7820 with SMTP id
 38308e7fff4ca-3acf3b201eemr1185331fa.15.1793915531874; Thu, 05 Nov 2026
 13:52:11 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev> <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
In-Reply-To: <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
From: Andrew Gigena <mail@andrewgigena.dev>
Date: Thu, 5 Nov 2026 18:51:44 -0300
X-Gmail-Original-Message-ID: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Gm-Features: AclHuK9TNVNMsMH-gS3LyhmcwXP0L8JEpTnOqnWuyNklory8rcuhuvvX8_jSoFw
Message-ID: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Andrew Gigena <mail@andrewgigena.dev>, Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, Bjorn Andersson <andersson@kernel.org>, 
	Andy Gross <agross@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I understand, I'll keep that in mind for future patches. Should I
release patch v3 removing the "Tested-By" now, or wait for other
reviews?

El jue, 5 nov 2026 a la(s) 5:56=E2=80=AFa.m., Abel Vesa
(abel.vesa@oss.qualcomm.com) escribi=C3=B3:
>
> On 26-11-04 18:38:13, Andrew Gigena wrote:
> > Convert SM8150 UFS to use a standalone ICE node.
> >
> > Move the ICE register region and clock from the UFS controller node
> > into a dedicated ICE node. Reference the new node from the UFS
> > controller using the qcom,ice property.
> >
> > This brings the SM8150 device tree in line with the standalone ICE
> > representation used on newer Qualcomm platforms.
> >
> > Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> > Tested-by: Andrew Gigena <mail@andrewgigena.dev>
>
> Tested-by tag should come from someone else, other than the author.
>
> Authors are expected to test their patches by default.
>
