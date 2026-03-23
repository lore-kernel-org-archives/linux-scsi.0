Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A47387343;
	Mon, 23 Mar 2026 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257579; cv=pass; b=ntJRVFRy9UYHdGFW9RgLkmb2B8r7EPHAEeqluOdMmKP1ztOLDJVPanQKEWclqJu1bSxSHUcEHEsOa/L1Wr0b833gv07pPdKTRczSIdrPmtJT6+VStfCMs61ONCp/h4IuhTOW/GgW9juLoeQu12/LqApEuQ4utmQyIXs8rsd011E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257579; c=relaxed/simple;
	bh=708IEs+ZtEar/L1oYDC1ix6XhGQMXuh8k/G3iCJLjKI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eCF3cmWNO5L3RzoKAP6kzZHB+i1dPnyw/4CwyfWJWW1EhvXmfleWd57BIdRDlfBVkQRGwyboKKK975f71+7L+wOqdRuoycQ7+c92mIQPXVLE/TsKjdTzpQBvuYwPgSOJC+HCuetC1uiKLJsd1I7MN2KiwmglJAa5skW2su1ifYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Cr5zFLpJ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=kv22qmIn; arc=pass smtp.client-ip=81.169.146.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Cr5zFLpJ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="kv22qmIn"
ARC-Seal: i=1; a=rsa-sha256; t=1774257396; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=V+aRzFHUE+OvtUe0zmngITvv1TJcyH150s9fHSn1qRIgPk4L6XvBP6RDnxbnPZ1o42
    RmEE1dUm2GRzfsb8k2l2CcM2LZ6Af5SqZ8ytSmFUSCPpn4CLz39w3YYqp1LZ0f6mv80s
    BuWPzQMbB9yfeIlfUCHZ16SbXKVz9sKIwbk1L6QPniHxcxhVsbebItf1eBg6XposYZlf
    8oYTR/xnMbutyrgHpZ3bbKz4zxdAZ/i5WZZvg5qlVXm/11jZ90a0M2Gew1eNxHqDlZNT
    os/pTigybzeaiq4zzPlHwthEnw9YkMPJFxeUPnF+ffZ+vu8uKS2gtsLrw+9lsCHgw66l
    fz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257396;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=708IEs+ZtEar/L1oYDC1ix6XhGQMXuh8k/G3iCJLjKI=;
    b=ER9L3vFgDueycub8kUQiEUmo0v3Sfw20HffkQwNR8LT5OQFRlSSh2JnfvXN05M+ZCj
    sQDUEWiN5Ba3FnKHMaKbv6bsbJ2AXdJLpOnxOhTb/WFTjx5YU7VsB7+HRT8U8X9gsrUL
    k4YcFfXhc4Y6GIYXeiw6a3sqoebV0hJf7mSBXOyTyj4ZY+lSGmJfExegh2xJX2BZg2Xe
    B0sh64GuN41azJkgPC3mXLSMOS65xEuRU7ZgLJUtgJED8yq/EjLync2QvZTSfhcJRX7o
    0iaywpUT6M/fQPNgMlUYAa7t/mPc86Zwi5gpMML7k1+Jv4+smpX22bQhh/7dThTErH/y
    49HA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774257396;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=708IEs+ZtEar/L1oYDC1ix6XhGQMXuh8k/G3iCJLjKI=;
    b=Cr5zFLpJ/psQruKz4M5Ez4xq7letRsg92/xxPK6GKwy8CdYvDyYcl0b+l58JsKKPMT
    0LJJXCvHkY2egurcOEijCUVhjr1fQcAoi0GOUDmvxzJ+5PZim0ur1jEEjyGcNuuFIpWL
    QKMHC8iOE9howKWW/Nhj5j1kFKu0EUQsOzDtfhG6SUVrg4bLKHjH5U1HtzWYKGJqbQhf
    6BZ/2DSzszJs4/hZrQp6gGmUC9awWrRhTzhoWWcahScgNhJdWt+HypPg7xxac3Wm4AR+
    xjDb367KM4DjWkABH/uP2fn4fsvTczAs+J1bAK3D0Gx90ciNjJCzN2kGiub6oDhh1WR3
    oy3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774257396;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=708IEs+ZtEar/L1oYDC1ix6XhGQMXuh8k/G3iCJLjKI=;
    b=kv22qmIneivvxoP8pSL7DaB7aUaEbgtKCL+A3NisB6avg+P3HqJevLABRK9L9BzCAi
    C0QmXyAQ8qm8rTHo05DQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522N9GZQLi
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 23 Mar 2026 10:16:35 +0100 (CET)
Message-ID: <150ea7ea4a7f0facfb480b4bb6fbc65c13d544e7.camel@iokpp.de>
Subject: Re: [PATCH v4 05/12] scsi: ufs: core: Add debugfs entries for TX
 Equalization params
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:16:34 +0100
In-Reply-To: <20260321031021.1722459-6-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-6-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> Add debugfs support for UFS TX Equalization and UFS TX Equalization
> Training (EQTR) to facilitate runtime inspection of link quality. These
> entries allow developers to monitor and optimize TX Equalization
> parameters and EQTR records during live operation.
>=20
> The debugfs entries are organized on a per-gear basis under the HBA's
> debugfs root. Since TX EQTR is only defined for High Speed Gear 4 (HS-G4)
> and above, EQTR-related entries are explicitly excluded for HS-G1
> through HS-G3 to avoid exposing unsupported attributes.
>=20
> The ufshcd's debugfs folder structure will look like below:
>=20
> /sys/kernel/debug/ufshcd/*ufs*/
> > --tx_eq_hs_gear1/
> > =C2=A0 |--device_tx_eq_params
> > =C2=A0 |--host_tx_eq_params
> > --tx_eq_hs_gear2/
> > --tx_eq_hs_gear3/
> > --tx_eq_hs_gear4/
> > --tx_eq_hs_gear5/
> > --tx_eq_hs_gear6/
> =C2=A0=C2=A0 |--device_tx_eq_params
> =C2=A0=C2=A0 |--device_tx_eqtr_record
> =C2=A0=C2=A0 |--host_tx_eq_params
> =C2=A0=C2=A0 |--host_tx_eqtr_record
>=20
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
