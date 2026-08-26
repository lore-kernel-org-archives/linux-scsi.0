Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978712D94BA;
	Wed, 26 Aug 2026 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787754797; cv=pass; b=JmvTdAVgMQocmfOHZtN/a46Djsav8TF95bkSNrSMYypplUZof/rRAkBnQpVbKyC9E5I62uXNJwdL8cLtnPNHM0bo5IkE5GpGzwzCQbQwPA72u3yNX+P6BEm7i63GLzDNipoUzRNeLMvhGzOExsxh/Xgt0nrv77nOOv/MVCuh09g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787754797; c=relaxed/simple;
	bh=QvKF5mld8eVJdis1fhEPFCmryqDF0T0VDaffLARmBjw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U3pbRTKhi3PyR/OKrsb1qzacE41PT8/vLKBAonAyrUvRXiDhi3F2ORZ8EqX8wgzHRvGuyqOV9G1YCQ15Adk8ezj+w9T5ad5C8ADmChD1MzAvelqy/gY8+7gMAdtiv8/am5C8tzTAGnUzF/Q0WeaA/oKIZBI8PPgq0i9MT9bVupA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=tTMgJUKQ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=+YO4xrWf; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="tTMgJUKQ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="+YO4xrWf"
ARC-Seal: i=1; a=rsa-sha256; t=1787754768; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Ky1y4V0NfpLFynWYs67/Djxdkm5nTyMlj0s7/yBT3SOzuF5WTYi/EFbPq3EBH6vQQC
    NXRrGfOrV/1I7vvG1ObQPCMiCcrps9v/UW4noSQUc1oPZu9zM4xkU3vf6fPhIJ5qsDrb
    Jtu1qjyDRWhwd9Rb0E5D9VYGXaU1jJ3PZv3wiEf4MkNO4xul0oROoYsB5Q6wZfNEeoeq
    oCURF3zbDa6V0xiM5fssHnhITnzJcZyKcRvsYVOAiZN+SjmLfs4k3gnJqS5DYlHbfZzA
    W1FltzORwFYYT3vw1ZCjSk10OElFVNEhWxcLX4Ntf76r62+DjoiLvPQiVrU2FL5zDyI7
    ao9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1787754768;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=QvKF5mld8eVJdis1fhEPFCmryqDF0T0VDaffLARmBjw=;
    b=VvqsIGpYqpQ041FuNDsXxBh/2dXbWvS+ZlDnxvRZgxbMM+BRTocQzafSwmf2anVoJn
    q/pzxMcGrRKFBRag8gLFTBB++Q7oRznk+eFQRcfDu82XvauV5rGLwa7ZhToXr9NdIO8U
    1BcxIa3AE27SFac9ErqLgWfgGwWnPiuUhvGJaTk2rPLQNs53hjF88NNwxx0FMKl9Qaxk
    rFvOx19BX/b3ZKi0sYPLExNzQVlG+igaBI2P5AqX1QCRBiRpPDNFURIP5g4dB/u+3hQ8
    wKRPa0rJNCDuq2wvI01oTqfkn1yLv/qgHKdHf7oW0FbXpM1+FNcX+BootVYa/gUe88lv
    w71A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1787754768;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=QvKF5mld8eVJdis1fhEPFCmryqDF0T0VDaffLARmBjw=;
    b=tTMgJUKQMTabq/YW6iUeiy67UqhVu90ul6VTIjklRDxwnKpznqgbxiWAcL4VrfDfPa
    MBR288o/340q5MCgkUMIbd0h3rDAw4ZeZ/dnjHZF72Olp+CvO1bQyTt51cfCBnqYXSt/
    rlvKOS+Gj+3A4TOu4HSj7kNslbJkhojspnsIn1upLRq+9Yn0PTAhPpBiXc/PelohTEhJ
    WBQHIoCUgqQ0WHsKw8hvXPhZjwygRt4FWVLai3ZLAb13b/qM6VZWEO/m3MvHV1gKE6gU
    wka8GS5V719k4ND/yn+BTo9Y96Z8KPBOoSMV0xypk5nHh0adxfzagtB8k48fgUAwhzSE
    cPUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1787754768;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=QvKF5mld8eVJdis1fhEPFCmryqDF0T0VDaffLARmBjw=;
    b=+YO4xrWfR9DJIxYw+svCkXeofq+oz1c4fE/TUsLok6uCfAC4zGctyxwNuvadARirOH
    o4biC6lVsnETeAqoH4BA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127QEWlUSo
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 26 Aug 2026 16:32:47 +0200 (CEST)
Message-ID: <c041d409bf6f564c6743a0d03e0c851ce3afa6d5.camel@iokpp.de>
Subject: Re: [PATCH v3 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
 sumit.garg@oss.qualcomm.com
Date: Wed, 26 Aug 2026 16:32:45 +0200
In-Reply-To: <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
	 <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-21 at 17:06 +0200, Jorge Ramirez-Ortiz wrote:
> The RPMB authentication key is derived from the dev_id handed to the
> RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> is the eMMC CID, a fixed 16-byte value, and it derives the key on that
> assumption.
>=20
> The UFS RPMB id built here is "<device_id>-R<region>", which is variable
> length and longer than 16 bytes. Passing it verbatim would tie the
> derived key to a length OP-TEE does not expect and diverge from the
> fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
> UFS ids.
>=20
> Hash the UFS id into a fixed 16-byte dev_id with blake2b instead. This
> keeps the derived key stable and unique per region while matching the
> eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
> identical and no OP-TEE change is needed. blake2b is used because it is
> already available in bootloaders such as U-Boot that must derive the
> same dev_id, avoiding the need to add a blake2s implementation there.
>=20
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

Looks good to me!

Reviewed-by: Bean Huo <beanhuo@micron.com>
