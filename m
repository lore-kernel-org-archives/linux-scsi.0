Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468663;
	b=1dgR2exYlSI1hePL9s+/7CxVDkdgq9EgbFkpqoS98l/yA6rg/WezEDeHtEAx2Uz2+W+K
	 NfLjSP43aJ5JCJ2Xjz3ggJZKAIXPve0rL/hJ2hJ9aCYYw8a+8cJGqvM9QvPYKkaXZOpgv
	 wzmTQghuniFqAf8SQyR9NeG/r4LVHxW5zkxAi5MXUGHlww5NeBe4y8f3Cvo441uRnTPmM
	 4FVnBwThLG2oMRchKSHQw6QbfFUJG9+StlAMIO9AwxFm9b7IVJcKul4uh5TfrXKZaDkS6
	 xrzRdPa9B0dnSEVLWFj54LVySYpAmk+0Gi48+CHNs5ghUB4DkqyYyJ41xx/T5TzlNwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468663;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
	b=yoyAQ/vto8zyGEJWnTEbSX3f8Zl1Vo2fTBroDuybX4cTAl8yNoU51p+3FLJRDG9XcYz+
	 vSBKhOSSdDXNB4Ql4UUilQIoUiPlYIIBnJl8gqG1qX8nYPBFdlM1nvKQLXtxS2QOjKVfK
	 iwh8Pdugc+TdGcyUj/IE0qhI6Iow8YbzFAi2tj/027K4VRsHglXDTJru/svPrTsqrd959
	 Hv2K1qYKh/J7bGiim9YUVfYiXQm6pVJemL4C7K/FBlfc2xw36zsYTUs5renlpnMjGeTzn
	 /PpjHAMkdiij4ZaFz/+b2RVhgHlPNCd/Cp39xpvxPJlTxblUyo8ncOCon4ZomfEoubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0fedjRZx;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46238606A33C
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 21:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46238606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0fedjRZx
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4a9be758734so2317484f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 13:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795468662; x=1796073462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
        b=0fedjRZx2RaPeNewDfT6kMMnjXVPl/B3fA1gPsEqLujR7kcW0NYtdJYVaByQandrUq
         QJzBJ4uC9eS8a+ayksMogNxSExWs0eNFKItvTDKAx6NHc5x9hqv9RQlhAAzaAg7s5gs1
         9sbtbyps4kPCKude8iZa2iiFH+utWXTUN8TCJqFX8mRmvPPMu6I8nAQcyMZ4i4mpzyX5
         Cp154EF42lPno5OVkcDwnkP37Yni0BUszr0xLEoRsNB5R9GRF4fxmXOCy5ua5f8Nqhrg
         4AybiECJ+X7fZBXujwbzZQ4s2TiblfJ29wOS+plEAwzRWxdPuG712xtYts3o3CIOU5fN
         1RVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795468662; x=1796073462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
        b=foKCZj59ZnuGjyeVhAhHrss1VZsZ5UM+xrX41Vi5tlG++5OaD43GsVML32uFmp8YjO
         XODiVUZZYpJsHN5y+fl9O1y698j6nsCoqAb2vLlaTBzCxwFQAgjd3Ju+Rw6yA43njiQM
         BbOc8wUJ33CzHuPXLEUYD7o83xBlAEYEovGMGKXD+PZ4RwWbVYdJ2VkJoNl+U9/3XhE8
         DvMDgb/bmWJ1q9X2Ip6SukyFeOseUCo4P7Ce/MKI3MhySMIqaXFNisBEH0wFTvyYavyE
         ptItndeVDsm9I00nVvWR8HS9JAXd7ET6gF4IWaxVUHL3UedW85kW0dqYG3KkvBU7gwja
         zOMA==
X-Forwarded-Encrypted: i=1; AL+hErG4g3T1Y1ewl9MMxWFQ0xO1efNI+fJf4gyfO3CqQfR7nC8F8o3mTP5e7qWy7FKok97LYRCnzwLLhmcc@vger.kernel.org
X-Gm-Message-State: APuU4Z//8ImxrvsQPzfNdMAcoSrFr/7qrPU/FgSuy99UyOkPHJuBmggL
	BlYDwMeFd1FcqRpDe3V2Y+sIbCAtY6TId0ry/X2d5bwVyc0r5mbEXoNJ
X-Gm-Gg: AZFdTZcMGdeV/twic5z4ZiuAHynz+bUVjqYrKcig7b2Ydbvy458YXeXVwf66HDO6NyB
	HEbEqCCgwa0ZLqtXwGYJ/VO5X5zaVBZRL9gxsTcLexiUQVEZYFp0FX9M9NPWnXzffKwCrb81wQP
	+UTYH5fRTRXjQOjxyXXAjGWAyEvIDADUu/RrgVyO9kckTifRUW+HAaHdMp3Em1RDskKtAMb6Kgt
	hZzeEu8UYFsDS9wnadLwg3bLJDz0ypLNtuiSd3D4pvszS/Yndc4JebWrxHlnUpU31KCYDe/UQVe
	znyShb6D3/Z83JtmypvxgsKWs7o6/5LmkIqCWiWowf6T6O/D7Ac4x4tvUTCcbgCLCiWTYgiWwn6
	/G5h5Os/MQIawFVNF0HfO8qPsV8il4R/rJixKAoZ4GNqBp7XPAAI2SFFtYXHlZlodp8Xe6m826Z
	pdc7u+kYczoBk9dKLzQPPoJ2VCP7bZuswOGR29GG5YaCU9PpdA9yNRm4MyM5JN5N0gkUNsL7Uad
	KYjjkl7AHTvdBrqPFKfXTdWHBqsYcxa+/Oz+7TDSEn8uFk2wbgjToh4WoMjfYSP3Akefe9N5tOI
	JcY3vJBLFouGZc3ZQFnEVt7pXG/q83QQisvlENyl3L4KVyHv
X-Received: by 2002:a5d:4605:0:b0:4a4:14db:2348 with SMTP id ffacd0b85a97d-4abb29105d1mr18698069f8f.35.1795468661504;
        Mon, 23 Nov 2026 13:17:41 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm24513121f8f.6.2026.11.23.13.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 13:17:40 -0800 (PST)
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
	Ulf Hansson <ulfh@kernel.org>,
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
	linux-pm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2 13/16] dt-bindings: arm: qcom,ids: Add SoC ID for SXR2250P
Date: Mon, 23 Nov 2026 21:17:23 +0000
Message-ID: <20261123211723.1065310-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261123-pastel-barracuda-of-rain-bce8ac@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com> <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com> <20261123-pastel-barracuda-of-rain-bce8ac@quoll>
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

On Mon, Nov 23, 2026 at 01:09:26PM +0100, Krzysztof Kozlowski wrote:
> This should be rebased on my patch removing the IDs.

Thanks for review. I will rebase it, but I am not sure about
the order, could you please clarify?

1. Should I wait for sending v3 until your patch is applied?
or
2. Should I apply your patch locally and then send v3 based on it?
(but if something changes in your patch a v4 might be needed)

Best regards,
Stanislav
