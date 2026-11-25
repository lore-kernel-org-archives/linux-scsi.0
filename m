Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795579773;
	b=oGezxMova20hK3xNk1Y10bpBjAABlYM/XRinRcxJHfX4sGW59GzeqcYbaJpiGiDkeZ2u
	 paX/w1TCJz52td8dou+jUc+bBeiukI5DfmxDuFq/3qjsD2oBKELrCk4x90+27DIFcN7m+
	 +cBIfHmrV77wWH1Q5XMKs5QOU02CMlE+nuFR348tmFsg3gZbwnqyRrEUpWNw0Wov78TPS
	 0+LgdtcIzct2vX/uK2ITCHn6KHZ9+t4fsG9saENp/6zEoDJR0xVxIhKhfDLA3heBQuDwu
	 IZBN2zKLUVUPKrG1T0O8hsMw66WfjyVeMHVB1swErTgg/MDeriOKld/ADitDpq6xDoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795579773;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
	b=AAZQGzf7j3rmhBNTxHvEJXItcybrop993vYm8X4GiVQo5ZFxq0MHm+YpKiC2BUDN4uH6
	 a4flKFSd/6g/FNrCjxhjPZU63OimsFJcuskxXYsHprz1yQvxSSBWoRZ+jy/IwROK2jXU/
	 9VBRfpBhJU/L/CdO11ZoLQghqA4QoCJpu9St0tiC5qTw7e4XYyiWWeyF4UyVeoiuLXwsw
	 G0k1640yPBpcAFSgrUrUH2+48wAVukQjumA9qZS6zJ0TFtNlOoPMprls3Jao2s4MuY2KP
	 XcOKRsfxWmrRgIUFS0j46P4TeR48Y0JLKn2A3BA0p6Rz8Fgvruwy2H3cSyZhUmdi+Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZwakwhmB;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51504606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 04:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51504606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZwakwhmB
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so4283608f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 20:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795579771; x=1796184571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
        b=ZwakwhmBUNFk5iieZQuNuzg1aYv/WU3M6e57aS/xhN8ERjUWlGzPwm4Vj6GhXU4RuT
         M5KfMt2t9wkGnlEFtmxO6DJu7e/h/EZ4saO8H8yUZAU5An49KWFI/pquGlJbGXGK7ahJ
         f3p7+yVN421LRBxmbIkePqSLExjExEtaMkKEqXIuB1g2BUyLeMduhdapnFoE9UDhI+x4
         qQtI4MdDCYzSuPSGGpLRvqpn4RbekVMD3UKzNAdefC8jaY09xl7LhXSAu6iYrb7lsVvc
         n84TkwmDIhen9PmVwU0vTW7KJbxeNHsoid/k/horLxl8mkyD59PrbGhDthSxUrcQ5HhQ
         Hb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795579771; x=1796184571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XR4oDLJjvjLlqtHJPH2Z7m3RTdZmrnGktJaMrZ+DmGg=;
        b=rX0pnU/zm26dNu9/b9GtznOWtt8rR58rPpBeV1MqlmcBFYO5SLPuauou7qxdeQyr2S
         eZQnb/NygsQF/xpGb4SuXPMV6Z9SlnZeQlDGdRmaTwa/ny5N2wuSJUFiSijHfHn1A28b
         4wj2nNlPg1veUmzDjmwTMECpB9zSW+XohhoR2t1rrP5YHaUcBb+rscEPRJDQBKP5UuDo
         XaW2tlZuWW8VUxF7r9DStPgXb4NgJu57BPi42IIggxXit0JOhAoFNraaeonIl7FNb6/A
         hxbc85igKovaIGwhw2PgAhcl8BIYdP0BD8dutLwZKJp04aAdd7hT82K+dytisPuyEgCN
         mOmA==
X-Forwarded-Encrypted: i=1; AL+hErG1VlDzRjypvsg9yCdqwPsW0u4Cx9uS/6MnHMw0fxMxH4uu4oCW/BBkQLaK9ZkSLyOfqvvQ+JSp8P+E@vger.kernel.org
X-Gm-Message-State: APuU4Z9wl2jIM0dNfdVR9HLVOAKIQv3aNgG7gXOWcXl7SdjXzkXksPfU
	7oXwFw6FHVson71EZ2Fjc9bWQhx8lWFfQaBsVw1Y+yLEZLbZufxNAd1M
X-Gm-Gg: AZFdTZcmDs8iRE6pldZbkHuw8R6qoqwiMmUuNAW4+c1tznSdVi7qByyRhTua4m/RO8o
	YWaCfXN0NaosKM0C+W7/6kwgeS/uWTQgn9K4u1kShkE1O7kGgeQH7iIYrtAxrbYx0yEmWPg7+y2
	cktP3wb5zkf762ttqBsDOHHmL/VZyUjSIXJzcMCi3VZDxvqEPiSfmHdZX3HADXFg5uPuDOfpfOl
	TbvUjRuPSsj/kHsj6xTCPR5RmEBT9TpIniOl/U5tvgOXokxw6ps89qtDYdBXlDLE5Gm+nv0vvpq
	jEGWQozZMX9GwaMxYzOR/a+B/dVM2pnteOcEgltAShyzaDQB6IXTignlqMUh3RPcJyuJfMrWc5l
	EodxCn33hNLUyXdX6wNgGchYjfH9NKkSpjAgVAUAs+VJ6q4iM9gVeVdp/fDnmZ0UFfKvbLbOwHD
	i85sEpT6k3tF5Km+dv7i3bXmmIbKi+xuetG+0XklfL4d3PlkQi1iuqsLi4+GmnEv+rTMkzl5cP1
	SlQP5mftja2bdk/tLh+foc5/AK+mf7K7Zdpf+tnDhMhVtJcZuqsn1I69fpe07k9mzeuyoNOH3aR
	TcmwY7+Xiw9Mhyr6dxIeKbzjh4s=
X-Received: by 2002:a5d:5888:0:b0:487:1ac0:32af with SMTP id ffacd0b85a97d-4abb47b0fb1mr31743230f8f.51.1795579770667;
        Tue, 24 Nov 2026 20:09:30 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b5f6sm29545143f8f.34.2026.11.24.20.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 20:09:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: sashiko-reviews@lists.linux.dev
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
	devicetree@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	olteanv@gmail.com
Subject: Re: [PATCH v3 13/14] arm64: dts: qcom: Add initial Halliday dtsi
Date: Wed, 25 Nov 2026 04:09:14 +0000
Message-ID: <20261125040914.2399053-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-232541@kernel.org>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com> <sashiko-outbox-232541@kernel.org>
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

On Wed, Nov 25, 2026 at 03:58:44AM +0000, sashiko-bot@kernel.org wrote:
> - [Low] arm64: dts: qcom: undocumented qcom,halliday-cpufreq-epss
>   compatible
> - [Low] arm64: dts: qcom: undocumented qcom,halliday-tcsr compatible in
>   tcsr node

Both bindings are already applied and in linux-next:
https://git.kernel.org/next/linux-next/c/7ceab1723610
https://git.kernel.org/next/linux-next/c/1cf95fbec47a

Stanislav
