Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C26199B8;
	Thu,  6 Mar 2025 12:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741265406; cv=none; b=RQdNcn1M0xDJvwFsjaKFWst1yh0oy62S0L8g8b+yNR+0kiffG9eDV7A5iuTMf+/eWjC5r1ktfwK/yqsR68PUgUbGi5lyuT3mLV9GJtxPvgGOlElzWHTt6ew7s9+KdnoUWGWVcYm2iX3ODLKh0Jox1hDBE9NTwCXgAon69yGEX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741265406; c=relaxed/simple;
	bh=a+G/Y7rybmvz3hjYnOqJRpDSsIxprsBLD30qBcYSPtk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rXck9/IRfVBb2DsoTXvb9qo65WtdO8v24VCEMTdkroPTYstWg5Miy+9fsVE5W1cM9YRbtrCAYCGv4reTkJWlEjgyw5QFfbr4u2DdMFt5jsKy77XCSfomjrcASavnd7fxqpffmmL64HWMx/oyf7GE0nX3JMEOCfiM1RLj3zXV4JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwP9XRNs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwP9XRNs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso3641825e9.0;
        Thu, 06 Mar 2025 04:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741265403; x=1741870203; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a+G/Y7rybmvz3hjYnOqJRpDSsIxprsBLD30qBcYSPtk=;
        b=fwP9XRNsv2pplL/C9J5oSMdflSeYlC1verlv4BfM1K+Ydruw8J/SPLt9zrWsQsM1AU
         RTLGFRrqz0qtk4Abaang10QRbp5SZldM2b7tr/JmcmRuk6MLpKfqD44IGfmdU+UtQWHq
         +tIQV7NeU90QVjGN5s5xtM+EtbVRY2Zrm8O3xid3tkpa0/qAREq71wb6z3YUTaF8VCt3
         8QWpcUxbmbPmnDL/reyVjakj/KesPprmUFtjK/qbCYI8m0iOtLZdNQXlH1FtEzEL143l
         qCcVFxkEvtksm0wSdOAp9SSTKI3kC+3W8Pm2PkkWTuAaoL65Hdvho6NhVVbvYPjOWD1Z
         OgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741265403; x=1741870203;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+G/Y7rybmvz3hjYnOqJRpDSsIxprsBLD30qBcYSPtk=;
        b=XJ0O+g7vlByiDncRyn3n8VsxKPUugdCAn1cFVTyhxyTzlwlEWGeVySTsDwFwd2P2UM
         YpdWs1w5H0yRiiARPb+iarw3zxygQotp+xFTZQu9+bGybIM9dS95x/GzWj2xzaaYhNwl
         Qo0NqVjovm/wLCHq+cjhf3hnLqdxJdaCU630YkNVLk5yBsyWDfeoe2fQvFJBgeKLFpf1
         Zy9393e1i7eNXl+yMKD1W7U2/I33yJTn2O8+9u7wJ8J2Kh22e7bIEJlSTk9t9mYRdNpL
         5yF//lkiT/QVXAUhFEyKpSRlNn+LMCKCZ7DsKii0Cu4eCi/XQqD3L7xsu4UhjX8N8s7p
         BLQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+hsF0a4hbOZuwTmTXFxt+ixtphvZGOqweEZRnClOiT2nv3nXN+nccnc4c/GAl4pY8X1IDLwyV7gpsgoM=@vger.kernel.org, AJvYcCXG0GzfgTdPYCsGZ+j8qVmHdBerCexMgxLrGKHZ5UXsaEq+HsZ1lr17b0fglas45A5xoLUGpYXI2WNIZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfr1GmaLnDQTm+v1dVMK+METFlJtUJiUhUxnGBu1KoUoRpPvx8
	PzK8k/pklWYBgq4k4sFB6hfdBD6WAHLX/yLm7wz3J54gCN9K7INw
X-Gm-Gg: ASbGncvOnrcjZYxHFHZrlFix/o1l7oXel8/CxEMfn/ZHoz7UnLn+vEsvIZH22bKMvaT
	yvF1zqtgxWRNuBN5woHNHIGgMyxT3GtWN93B0x9xHGOomsY9Yo2NwuAPt/Mmlf7fKaDtbAVewhJ
	zQ6xrG7Y8bDrGweIo/xE0VznVlT18DUfHpElX/OYopivTQTDi19lKdavX4oOBVS3jsYngCs50r8
	fRFdGvY8+NGpTijqe1Hydxj7ANc18LZmrAAiQ6+R+uwMialZAVylClk7BlIOoDCl9j6psuEHKl4
	N+UTbGUyPOlpUq7UhBweTKR1dgRGWV2tgNodUJhfkJonWa4=
X-Google-Smtp-Source: AGHT+IFYKvawQX/rJxkDeqK1TzC/LaGCItw/YHf/7XxfirminJCWvuPVTfeFgRwzh42P3STp9OX4xg==
X-Received: by 2002:a05:600c:548f:b0:43b:c0fa:f9bc with SMTP id 5b1f17b1804b1-43bd29c75famr57613835e9.12.1741265402883;
        Thu, 06 Mar 2025 04:50:02 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2bb7sm1961888f8f.63.2025.03.06.04.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 04:50:02 -0800 (PST)
Message-ID: <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>,
 martin.petersen@oracle.com,  quic_mapa@quicinc.com, quic_cang@quicinc.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bvanassche@acm.org
Date: Thu, 06 Mar 2025 13:50:01 +0100
In-Reply-To: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Arthur,=20

At present, we lack a user-space tool to initiate eye monitor
measurements. Additionally, opening a channel for users in user land to
send MP commands seems unsafe.


Kind regards,
Bean

On Tue, 2025-03-04 at 13:46 +0200, Arthur Simchaev wrote:
> Eye monitor measurement functionality was added to the M-PHY v5
> specification. The measurement of the eye monitor signal for the UFS
> device begins when the link enters the hibernate state.
> Hence, allow user-layer applications the capability to send the
> hibern8
> enter command through the BSG framework. For completion, allow the
> sibling functionality of hibern8 exit as well.
>=20
> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 10 ++++++++++
> =C2=A01 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4e1e214fc5a2..546ab557a77c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4366,6 +4366,16 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba
> *hba, struct uic_command *uic_cmd)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (uic_cmd->command =3D=3D UI=
C_CMD_DME_HIBER_ENTER) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ret =3D ufshcd_uic_hibern8_enter(hba);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0goto out;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (uic_cmd->command =3D=3D UI=
C_CMD_DME_HIBER_EXIT) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0ret =3D ufshcd_uic_hibern8_exit(hba);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0goto out;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&hba->uic_cmd_=
mutex);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_add_delay_before_d=
me_cmd(hba);
> =C2=A0
> --
> 2.34.1

