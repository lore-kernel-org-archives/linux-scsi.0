Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243864;
	b=n6+ui8QQZvv/orYg1IAXH8KAGnYoRM/8heCkeXRhR1YVcWKX5Mxsi9h3e+gP3Chkq541
	 Hm3byrqsx1Pd4zbtePHgZZmTpAhyHxjuxdpgi24jDfHkNsT2R9aTg1Tzu4IWFS6+62YB5
	 j4oecFqswfQ+9ILZwc6Di+ZRinUAruIEghcJV7toFHhgv0U8donPtg4QlKuUiwkPuguVZ
	 U4wdEzurAMxT0RQ601y7o2ndIck6fp2xnMoGD443coxAY4sgL9INlPk8oCYwch09rz6IN
	 7JSzHRBdOS3rV1LLAyuBiYKVbJtckMs24ai4TwDGlquyDRcUKTrLPFPvX4HA/pe49yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
	b=OiPQG/O8iVDbE6gYhmkFlfv+lRe/HEqL7PvyJxVTFwrcpIJb/j0I/+sCfSX+dwB1yY98
	 MoroBk6XFlc4h2nSYzKI5oPxZeRDnM8O+8vGYZKfg4pSb018KO5ov+qwWo7m6Md670B+y
	 QEeM7Lhkz5S3oY8m8u48L3m8cvxVsa1EmnCiyNXpkCWH6q3+evF9aUCIzWyOEt92KbnNT
	 wj5z+52pEpum1TmXCl9gxn78Bn4QMT2AA+q033Y4+XtB2/OaGDfgKb8tT577TxBU7K1X+
	 0EXsmbStm9ugaTkHMxgt4eqKcNoOQ6hC7Q1b5RpPPid1HIoLNtoiKAUB6j/PVEboSHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=INMhwymN;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44380606A330
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 17:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44380606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=INMhwymN
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1831272a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 09:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794243863; x=1794848663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
        b=INMhwymNUoXRa1HYjajYs2VDNOXoDzVIp/an3nVGMwTgqTKKIXcrYlToz3KguYeb2w
         0JSHPrAS4tp1u64diFxx98ot8r0Zd994Q5w09w9Wo7hRC/DtQLXBMMh5MnMbGm5sg/9+
         bfSbd1NNz976A12xlmIC5rBcyt2zgrNxYngASmeZZcCyhLh9b9uOIuPyOYnguxqTaeNR
         9hUslwRJlODcmrjO84K/MqZr6AW6G7obz3aQhSgpfQbvfDlBiGQqmaSqVNfiSLuoobIb
         SEhjw+R7G4bUMif5HGg+3AGlsX3R7zQQDPntqdP45khUAZLh8+Utt3l4+Gfo8W0GMqsn
         XheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243863; x=1794848663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
        b=XgWcONq2MEctlAK39kXorD0+O/Bbi7g2V1ho8HDozhHjscESSiEzAAPvuuV6pSU8Cq
         LqDX5UmuKcoQbh+r7uoCku6jNEfObI1D11NquG2SkiBm6skKqldK8OG1sZPU+zzDlKl9
         GdHV0gMYJEWBgJJfbv8GZaPl5lTIAFOECHceRCEO3O+vbQv1ya8+rz3Coyiy7XP8cfRf
         7dgi/3cEGruwKWLtTNmVsRqWofNu2NtzlQhvNzJjisvjdwg5MeoUb8C/oowsSJosN/s2
         90XYVNYXYO8ZYQrdlJJxy51W4GYofyIfspdgbceKgL/2JjItiUQRHAFqu+UpXme38SCU
         Rv8Q==
X-Forwarded-Encrypted: i=1; AL+hErEcnX/jUgFP/9Tdf8bD9hkDv+LBxyt+QGbN9HdtLrb81odIfsv3f2LWEopiz3Efo47F7dJwQemUK/BM@vger.kernel.org
X-Gm-Message-State: APuU4Z9fgNQFiea9V4u4IyPGuTmMqyo1MVt9amvE8SZoe4i7Vgt4YyRb
	rLuhNgdvk/GXx0f7cNDRYZSTuYfOv35Y+VDLiCVGl6aeAr5GrpWgsZFY
X-Gm-Gg: AYBFou3W0bfDnsucMDYsvKEgsVKwJ/ldXzgCOeyhlamG74rrJnOM265uh7Jph9gjbPL
	aRJtQGs0g8iLc77wL/19cWwx0+nAAeVoq4vu757OGrpVKOHv9bEXtnFKeIfydbc2uduXr3zFCm4
	HO9UVNP6QLGLXf2YMMeTaIOwpIqlzWS2PHhKnUpVVSkfxSK8NkmfKyi/uik1IQayeSUSosaGICB
	A4HgL/caO/7h4bPLe3qBZ2HaEaTNcOo1NlUo3I/z7abmLu5rUL+EoB/8HoNbbr/8R4P8iP/CIvz
	AVN5i4aj/LERQVKwsPJKOSXfTLtaVw17kdhWdGi6nKwZ+qoiRsDU98Zaosfuoeuy/NljrLPVjdm
	yi8g2Ao6yhQIr2qWfhIaKgequzCDIjPRoMRXW+9uyOStDPX4ZpNpFDVhddVndqs66iyjrw21mIy
	UL4XPBTs3SHvNjiSXu23bp2NMCoYdJSF9qICFvNKdxRxfsjd+H7bbST88r5xHw0RJ/C0JqU9F0S
	osuQEYq9uyW1HAmy3bufXMAN4VDMpVRDJUKPz2OXf7jge9mGyugwvnIzVM8Eq5BHgDu3dkxX16K
	Req9ljdrmm4DXX+8ZEmEUsoXlW8=
X-Received: by 2002:a05:6402:2356:b0:6b5:7792:d82c with SMTP id 4fb4d7f45d1cf-6b756ad7482mr185305a12.16.1794243862514;
        Mon, 09 Nov 2026 09:04:22 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ebe31csm1878937a12.16.2026.11.09.09.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:04:21 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
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
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
Date: Mon,  9 Nov 2026 17:04:07 +0000
Message-ID: <20261109170407.2073295-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-17-289114ab8197@gmail.com> <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
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

On 09/11/2026 16:12, Konrad Dybcio wrote:
> On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
>> +&usb_1 {
>> +	dr_mode = "peripheral";
>> +	maximum-speed = "high-speed";
>> +	qcom,select-utmi-as-pipe-clk;
>
> Is there no superspeed / dp altmode in hardware?

The headset supports USB SuperSpeed and DisplayPort via its USB Type-C
port, I just haven't brought them up yet. It seems we need a new driver
for the Type-C controller.

Stanislav
