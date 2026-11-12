Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794486754;
	b=5G+dJcXVrJuV9pFLcK2ZiwYarhvZy5wjYDhX5DeFe60jWDfzs6oGUObgIpw2BRhYLFrl
	 FOemFDPNSnbXx6/m/KVeCqYUISLJRzuN+ppfzcnBFG5OFL0pjm+Id7Qy3k15jm7Vgzdo4
	 rs7EY9dl5UA/rzbAb7epS+y5OdrURM+gHDott4joaV7Mk2Jy22dWzHx+/wYZp4tWrcEVl
	 nOGYhQ15gZLDNjLW0BndhAZQTeoKXI9niyR6bniX3erbyFUzv+wwrAeIAphbuHBbpquR3
	 tj/eCTPor22gJ40hCrUAVI/8A4Il3SItbJGVVI5CA3h+UVg77MyGpqOEMq8KtOUoT7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486754;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=y20l2F/j+XurdMoSjb6j9VkFomg1wilobJpR+q126DI=;
	b=rrBSaRMluR+E3Z5itg4yhoBCjlAvhteyEvZt5zyudajLeiEP34eTNyhciOUe3bhmGIBE
	 1EeNKo6cq3SA1fimYhBFLpj3lWuxQYiC1CmMGTDL3DzTg3sBDl1L28oeGUfwKotFPZLK3
	 muPr+fcAp4svRy5ZjZhO7Arjix8PE3BdyYBsxHSN4cs6N3PZw6zhgXC/gMDtnvVh75/LL
	 a2/1sGPCLfXa9G63mwf/IhVGkVk6n9R/evsBPQtZkD7m/XCO1ypFXQaF1N1adMrTj/BL3
	 j+tXQah18MY/flIeS1Sh1+KRGHAwgZy+AUDq95TH/n/+wL0+eeHdIAh7AHsew3k5qPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=OjK+AvZ1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD99606A321
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 12:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAD99606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=OjK+AvZ1
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4d58c50743so424948366b.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 04:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794486752; cv=none;
        d=google.com; s=arc-20260327;
        b=i1Sx9rwVtZ3+t6OzAwuAeFvCESWFDk5ntHAotU+KPxoNTAg2JiiAIkeGBz9VGA779r
         CarHr7vZBAujGH6eZT8uEt9o/zn6WlLxtG4ahssJMxVMsjG1FMZrxAvOqKPSPRp1Beil
         t+Yo4EsPPpEeYFq/BZn8GiBAScTdUxs0pGniCtUTGJFaPnRcf8HdwBwoi8ikj8Yj6nJP
         TwMa17Td56sffRxNpG4Jb3n+gMctEFICkEoi1ZJeOwAhkm7A5AifIptd0H0MG+mTOapG
         vEEzZqmWn49v5JOzu25fLGV+dXtFnwaAJe9kj/+qchC53ma7DcDGMVfBkSP4kC+6vuum
         FpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y20l2F/j+XurdMoSjb6j9VkFomg1wilobJpR+q126DI=;
        fh=7S5RPtF9rPudUw1EU3ob7+06EwLZzKKOI+cT4/9kAmA=;
        b=D2kJIW+RIe60T74DHT8UCCKG2aACM3NdEa1d2Rpm/jtEtfb37yNsGhG7aso0rLQ/Ml
         53IENA29WO3OxT4ljf9EzyM0O6BhgLqvEQCee1YfaT45DLM20dzjVwcPa63vXALa8V2l
         Fpp4nI/5h3Duhem+QFJRkP3dpwfJKeYGTR9o7gFZ4bdL84BZdM2F/NFfPH39zgCnUAdC
         uvWa/nbdTjB+IH1sMPXR3AyTD81qcq0CF2T6mxVN57eWWhg0M2RcdqJQPdQpszYJUMYq
         JtDC8VgujW1fm57lLX6ahoDbKRVvETmzIOiLpYsdlDbJAnYysoI4VAlJirYo+ToxcMvC
         oQ3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1794486752; x=1795091552; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y20l2F/j+XurdMoSjb6j9VkFomg1wilobJpR+q126DI=;
        b=OjK+AvZ1DD1zojUH4ETw/TDbfx7Zw4gwU3EkXJWq+VsqgI2jj8/aiQuhifH+4HMoCU
         09hMJYnvmNa6Pv0fy3KdZG3ZzhJxWOrXezkVIUQ2D2j1vToBTO4kidka0FvuyDWAZsdR
         mtTR8ufhrHC9CGiHEW8RswspdjVdmLG6OVh2RAG7pMExZQWtE13J/FyRInB/aMi0VYqD
         41nPoQLp3CIXvn43cY8knIDKW0kVb8L8lMG60jvvKSJ+dyXid8n081lRCJV9EITTXW4v
         1xZ25avZmSW/ycSkGGbcuNEllffu9q9RHE8kNEDTQ+80j0BwGw8wxEkU83mAmW6aISY7
         LDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486752; x=1795091552;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y20l2F/j+XurdMoSjb6j9VkFomg1wilobJpR+q126DI=;
        b=KI2QJ3M+Rv3yzoPq9ND8+J+4qzoPm/85+MHBcPKEk3q6QWCBDlcRcEmf2dput8+Fo6
         C65jQodd5Zn2SPmFVsGXEGmPzc9bcB0I5wO+UzeKCfaIanDibFXGNidcZGE0vEV9kYTu
         VDvOPBqD7W5p+jW3JE54BlDvepaHiioJB4J5xLW6hmeoYKpOKwBqvWtNCkPs1W+YKPF4
         4V9AvQ7MLkVY9Gj9Ig43bTaxyn6G1F7RBUFaxCyaA+F2/OHtOsPMUdIiaxFPb/8w7Fnh
         L0X2L3v1nRDcUuy0uVTdYR+S90Hxo6j9tFzw55lZqihNavozxHgZzkkRc1Wjag1zf0g6
         G16w==
X-Forwarded-Encrypted: i=1; AL+hErHihsqy5eq9L5vFwTKrZQFUPSdqMMFfCTTxO6NdrnDlkqSRbbVTxvRVINqCbtUrExYZCFf8NwNFxyRd@vger.kernel.org
X-Gm-Message-State: APuU4Z8e4wMbOffQd2irv/4ON8jDsQVyN9QnQbJ2TKM9fhuAr2Vfo+pK
	KS4Ur5SW3VZ+Ut5Q4mzleAct62r5QsYCP6hXnaxbrTg2YlU5Ewm/ZDHgSbbTqheohBLq33CZR7p
	v0QzU3u+tV5LSfK6qNo8VNrcDKOTXvDOjHUEzY0OY1w==
X-Gm-Gg: AYBFou0eBVUVo1unBk3SGXz+CIR0YfV4ea9zKLSRQ0Bfr43ex9kPZfQgGbPYEuNGMOQ
	1xhGFFwWtwQSBZ4RLqx9CH89G0MrfyFFsPVAzaU5mPEPGITCNJMkd85W3pMB8djiu1acqSThgp/
	OL3qEAWZTnYs5tpWlLvmsIQnOyQZCqFx2HlgQZDqNErHm9qvoQqAqQvJOrRMqHpryPWsSP4PJYa
	8hvxYR/GpuKVBg8rO2TFRFPh4MrWInziSwO6zIasWuRzT4ffv1nBQUImbJaIwaB8UhJFqKZHAj/
	oYh1GVJG0XFK9DgMswMestwT+S0PkJoQ0jB+WIiXmPY+5I9B8CJTkT5hMiv59ndlX8GjStNaOYh
	9Sun3jPRakoQOsQFf98d/sYb93zaBr8tCgYhaIWNbRjsz50QkMeid9AtpbeHjSGiNWNeupkw5jk
	ktbwoN5F2tUA8Gpg==
X-Received: by 2002:a17:907:d78b:b0:c40:80eb:c543 with SMTP id
 a640c23a62f3a-c5066983d05mr436745566b.4.1794486752131; Thu, 12 Nov 2026
 04:32:32 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112004112.3059801-1-stanleyjhu@google.com> <20261112004112.3059801-2-stanleyjhu@google.com>
In-Reply-To: <20261112004112.3059801-2-stanleyjhu@google.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 12 Nov 2026 16:32:20 +0400
X-Gm-Features: AclHuK-MWQP-owK8xO388Y6zrGZ3GrYV1JBK1tcff5OGBU0shzAmKP3lK-2IbRM
Message-ID: <CAKTNdwH9+xsHEQ9wMztC3QSFUBUmYMtLAcAStSGB+TFFrcWfsg@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] rpmb: core: Guard frame requests and teardown with mutex
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
> rpmb_route_frames() invokes the provider callback without serialization,
> which causes two races:
>
> 1. Concurrent callers on the same rpmb_dev interleave multi-frame
>    authenticated sequences on the region's single result register and
>    receive each other's responses without error.
> 2. rpmb_dev_unregister() calls device_del() and allows the parent
>    provider device to be freed while an in-flight rpmb_route_frames()
>    call still dereferences rdev->dev.parent, causing a use-after-free.
>
> Serialize rpmb_route_frames() and rpmb_dev_unregister() with a mutex in
> struct rpmb_dev and clear descr.route_frames on unregistration so new
> requests fail with -ENODEV. Also update the stale kerneldoc note
> advising providers to unregister from their parent release callback,
> which cannot run while the child rpmb_dev still holds a parent
> reference.
>
> Fixes: 1e9046e3a154 ("rpmb: add Replay Protected Memory Block (RPMB) subs=
ystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> Jens, if this looks good to you, an Acked-by would let Martin take
> the whole series through the SCSI tree. Patches 2/3 and 3/3 depend
> on this one.

Thanks a lot Stanley!

Works on my Rockchip RK3576 with two UFS 2.2 parts, FORESEE C2G071 and
BIWIN BWU2A0526B128G. Two kthreads issuing GET_WRITE_COUNTER, 2000
requests each, without the series (bus registration restored by other
means):

  FORESEE: MISMATCH=3D3814 ERRORS=3D0 (plus wrong response types)
  BIWIN:   MISMATCH=3D0    ERRORS=3D0

The BIWIN part keeps the responses apart even though a trace on the
RPMB WLUN shows the SECURITY PROTOCOL OUT/IN pairs interleaving, so
the corruption is device dependent. With the series applied both parts
report MISMATCH=3D0 ERRORS=3D0, and the trace shows each OUT/IN pair
dispatched together.

Tested-by: Alexey Charkov <alchark@flipper.net>

Best regards,
Alexey
