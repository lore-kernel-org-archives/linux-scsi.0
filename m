Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794486872;
	b=S6nFVt9y0l20F1Ml5SzmNllWhmMNZx/EJMT8IIRo86FZbutWFEr3bd/q+J9G7vOxR5JI
	 k641vQo7XNORYAZTvCGuLSGUb9ULH2kDg4aGH/f5E7EHKgbwirz3//+K85xfvU8GImuSC
	 IBZwshAi5d+qvew+qcilxKSDpDwbNqsU4t0ZfjTmu+5DDfeHbSg4eHxBOMeoNYoU13qIZ
	 ZznYJ1HyeV3m2Gs9z/sy5Rh9OM7V8OULASxX9Gk0fKNZWsWIYVl4MRDUKthJNAI97hwxI
	 nUc3k+oQidvM7ye7iqYnyA0ic5ivEcJLBCkVFhTngXSN1Dk8elEZJF7czLJZNePfNyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486872;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eNXeH5LCrfgsfYlStn+hfE2r3BpfJ4YwRHB6pNDWPmY=;
	b=09eQOXXAXwHSC40dwV7wwBDq7m0h3ouPKj8nRNldkVEuIVlBCwlDX83AOhW+OHUDDF9T
	 B0VrjynnobN2iy6JVtRad0gsoWAvDUo77h/wOme5K/3NE7nI/HM9f4tV3QYmSTMCykLEo
	 Oliq8tr4JNTd+TAo+Ks1d7a/UawxYQoQSvCokBByXOY2hX5UPE8VqNkYU5hW4cXGfzTCL
	 FJ7HOUb9MhmQfU3lAEjJESehkCwDPOlO8psywIsCrA9IT6s+yP3VxeU0h9ftqcczNOLbu
	 BgPiPzGczfvAa7xCyxjI1juCB2kZikCWmFNfbeYQUWvM8mJWxYWlL9tb7Yb2KjLuIUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=sCPuYaXh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64232606A31C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 12:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64232606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=sCPuYaXh
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c3fd91337baso709047266b.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 04:34:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794486871; cv=none;
        d=google.com; s=arc-20260327;
        b=mSuWPR1NhRqsrAG13Cr2aChjTqCOSREilGNr2k/L71WFjMNrr1LG71U/iep+pSemrD
         jGFPpO51t9BQEBo+jCtrUzbOB7BVv6eBZuykEep9p6llMpxL6eXewcBzE9NZ+QDK+nUe
         09yd41aE5C58NslRD3M9GWwpmyh8dPNSPWpAATyxzIavwj18TC5gCZy+kJNvqgb+fasv
         zPaGKiCMKKUl93D/1f4aNSRuG9H4GIC/dc2em6fAe/kWAk4kolnyxlIng49hPKTzwfgB
         xq+kPf+B7qBAjOXnLW/jAU72jj5fQv9fWyi1tSvryIuEAYdJ4bhoE356Y6vvAPLwOrH0
         YLvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eNXeH5LCrfgsfYlStn+hfE2r3BpfJ4YwRHB6pNDWPmY=;
        fh=cp6zTGFEzTCTSjkoEbrZkZUFusheSzMKBMjpQVR0QqI=;
        b=oq9l14J4mYSW640qtZkgO1dmYvP2nhD9xzhbARgNaLjmtvdqfJaKJ3ZGmbtUiMHSEd
         jH2BY5OwFn6mChX+U2rhSw1dZtZSE5NxeY+mlQpqJE3RAF6skY1kz5gyBIKHNhOyFN8U
         xW7TmG7JUrMhMq3lo1lDmPC5hwArNI5Dau4U+ijJ56F99s7ChoIo+BrivEkHoYllXDLj
         P+mBMbF1TtodjZAFxxiiIBG7jPkehARD+vjptZho6bQzIu1LM9bnJCoHG7SfoyhM6+Ar
         SLaB87Z/gKq67F7Eoucerz+p8fSvURhKctOxuA1AF2C36Us/KN/UHvWPG2WiE8TpKdxN
         Fo8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1794486871; x=1795091671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eNXeH5LCrfgsfYlStn+hfE2r3BpfJ4YwRHB6pNDWPmY=;
        b=sCPuYaXhuvX3OKDkIpxYBuIbiKheZ8SR1EBQVIL3zARYV4e17hLKFLTcb6vXqiQeZa
         l0dHGIT75gnoqD7nst/Bj8nmCNuP+3whj284/D+u/Qe1edeJpcn7gIqz3GQzzQnFiXgj
         J6nzTeTaHknSowu3C5i1X2QuvTDidqE2sy+QOUCb1/xCnXkgmODIroj5BddNzfLxPhTu
         3LE+Pki662mNfR32peU1FBjXyWP7JUavOTneDKFgMB+DTcZfiCV4CuBWm2fVS8p8Ml5U
         OOXLVbD2VnielBdjLss7W7xZ5IPtNwl9IBMY7Nb5KlR0EEefoAQyvMq8bXyWyn71Wxgr
         BLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486871; x=1795091671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eNXeH5LCrfgsfYlStn+hfE2r3BpfJ4YwRHB6pNDWPmY=;
        b=2To9/aqwlrhthKBqlKIJv8UnLQsX9HL6smAQw6kPiMr4zFqg8R6jZHAHByWcQhllTw
         hgIudlja/3P3bhAAfWOMTDpvNx3yZdd9xVlOS5dTt5rpA/U6CZoTMDlzV5xGSCwkIWK5
         Rndqq8ZJ7BEX36LYRb57Im4rvXkCvb2QSgF+ej+ILRfbS4cC3zlebEjDqLKrYM77dB83
         9iDQi0XOXxRh/7XnOyzIsXZWQloOBG407rx1lBuPZQVOMSINNGzk3XNgw7cwH7nffhxR
         Mt5a/9MdTG2Wb5sn1Oa2Tl2kJRGB6xy0DCOlV01K2ZrBHr6B/z9MLy8GMOUgcswDRStH
         ajaQ==
X-Forwarded-Encrypted: i=1; AL+hErH4ycD1N7Iuy8bj5X+7fvqqMayR5jVNeXskoBeHmCWF2K2DbVGDxYrIp9WlZs48LsWY3RgTugU3eWME@vger.kernel.org
X-Gm-Message-State: APuU4Z/QLB9RVejjneWWEVQIaKdgBcWGrDhc+C9/y6PnYX+Hb4urMCPD
	IixrwFevLRy94HGhT1WkFAZntXUMVyqXLPl5Xtd88VF1SsTSOaWt8PFh2pyRw7tmFADa5Jfedu3
	TvlB93uuGJND4mTxM4aAFmdhu6IRTig4qflz6/HI3Rg==
X-Gm-Gg: AYBFou0noa7D/5tdhoJcoqm3nqPwnw7IhwdTGYeGi5k9reCoabiw3iaZGpkyQC3b0ut
	Z87E0AzKBMM2cnJEdi0JxU++brHGKtmxEpGSB7AY2r1P4chkhiycmZ1R/ujygt+xh6tVzNK6ahC
	pUxeHULif0X4NpceAzqyZVyoQbGLf00NVfSUgnhco8ksQwDsxSO3zwm2Y7DsD1ym+ykm4Emt+f6
	aPwOVf5ijoLmp0ITMx+YXb76fwjTZF2dyPLF0XtZPTNdRJqwQ7odpjh4onKvOOUHYgVzOkgOx56
	PFp2Wx8m0XiGrTIv2QytlKEUG5gqW4HZYC78gymEDWNQLmFqQmCSeidZXl6zc2HQfyGD1BK95wf
	VVWJqi4njcwQDT7oWfMoSd3tfIek72ToL3oYuC5eQcGfWoht+Lj01l23ZvXd5Y8Yg0jTW
X-Received: by 2002:a17:907:3f8f:b0:c40:f9ea:7387 with SMTP id
 a640c23a62f3a-c506686227fmr432811366b.6.1794486870749; Thu, 12 Nov 2026
 04:34:30 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112004112.3059801-1-stanleyjhu@google.com> <20261112004112.3059801-4-stanleyjhu@google.com>
In-Reply-To: <20261112004112.3059801-4-stanleyjhu@google.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 12 Nov 2026 16:34:19 +0400
X-Gm-Features: AclHuK9VdUPb8KJpIagx3SivUuengHjj43Y_p7OZLWE06PaZD5Va3YxyrQkDtm4
Message-ID: <CAKTNdwHj2YGwX6mGxCbsDv_H95y+ofKGit8R7aLiEOCx0RdWQA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, Jens Wiklander <jenswi@kernel.org>, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@iokpp.de>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Ulf Hansson <ulfh@kernel.org>, Linus Walleij <linusw@kernel.org>, 
	Shyam Saini <shyamsaini@linux.microsoft.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 4:41=E2=80=AFAM Stanley Jhu <stanleyjhu@google.com>=
 wrote:
>
> ufs_rpmb_probe() assigns ufs_rpmb_bus_type to dev.bus without ever
> calling bus_register(). Since commit 36f35b8df697 ("driver core: reject
> devices with unregistered buses"), device_register() rejects
> unregistered buses with -EINVAL and UFS RPMB region registration fails.
>
> ufs_rpmb_bus_type defines no callbacks and has no drivers, and
> consumers look up regions through /sys/class/rpmb. Drop
> ufs_rpmb_bus_type and leave dev.bus unset.
>
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS devices")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---

Thanks a lot, Stanley! Works like a charm on my Rockchip RK3576 with
two UFS 2.2 parts, FORESEE C2G071 and BIWIN BWU2A0526B128G.

Tested-by: Alexey Charkov <alchark@flipper.net>

Best regards,
Alexey
