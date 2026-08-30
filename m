Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58511231A3B;
	Sun, 30 Aug 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788105958; cv=pass; b=UZeBrs8uC6HetueaIAZlyA98/9kb9AFvS6zUHqiwsaCdG/OTZKIeBM7EcjqWT99LkvrnTMZLMhQvROfHYNczN1B16TauXddEbLxD1cQzyTKl/IMUKsoKpLOfErGK5SJE9ppCWaW5vZkYiQVECHuftdMO9ZEn5rywUNwMk06xGew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788105958; c=relaxed/simple;
	bh=/AK2pwbuFrAO5t6+Sofph1O7MYFXlwSHtqydgrNy/bE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sEv0acx38XoCFr+f3LENL+UxvtgT9lVLToYyAY14Xsqq4xJTcPoIRjLK5ZDiWQnHI/lnluAm6Odc0QsV1Nm0vgBbuqmY2U31Q8RIIC+XdFxPGzfi6YRdXXEq6Kjgb/i/rwHD6+b5HhE/KbpkYedLth3OaYqdBH1E4pEzmWtTuK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=RpBA0sfv; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=WUXZ8F2Q; arc=pass smtp.client-ip=85.215.255.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="RpBA0sfv";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="WUXZ8F2Q"
ARC-Seal: i=1; a=rsa-sha256; t=1788105943; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ca+u/j8uOQbDAlxSYgIpQDr4Xe5pFULvOFnVXM2w4A0zxmHvWCg7RNRYvj728Aza0p
    GpiqmAX/E8hs0kk9tsZHQY5/AH0dRQmEPD+CRU080BCkMeCqn+cKIJXHrzgAF3EVI5dE
    q3zGV5LYj6QNFh3/1Qe3v0/5A6muqZ6AJcHHI3V4Tn7oHYMDphkVfaXT8kGfVtVYj5Ik
    H09UkBbp7SgTweakDYd+V3QzWgy6mL6uV2SdQNiAFpzwQK0nnXJ8FOr7luHTfMwKyCZ1
    jLJ9YQkQXOmUkMmyjUz6ZCsIr0XDA3nvmqkk5/plDHTSUY8oWMWhUA66anO0L91lLAFl
    e7vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788105943;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/AK2pwbuFrAO5t6+Sofph1O7MYFXlwSHtqydgrNy/bE=;
    b=PhwFuVftFTcZjTCErImauo/j59j7o/JzFuqBd2QvlTZsz4AK++VrhRHV8iIDF2sHVY
    jYt0RV48mPn3ZgJd4Yvj4y/dtU0ushkvmoOW+20L76N3gWczdlIiPNhGRdAPqUQPbW2+
    jUq7JXCskNuXRc6atGd2dVxB54gdxRh8aOBozynHMx1mP5JumicnalX8AL1/sfNguJaB
    jlwd6XbTwzrGrDuRf5x4YJNABIHFUbgU8kBQXoXfUouYQwR3qyBDcQGXzCDg0CpRIVJI
    MyqRe5IpK+/8FD7ZEB+IFpGJ/lBgl3+13D/OJllyPzo89vjXOjY/BvMs1VSdv0EAMgyM
    ivTQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788105943;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/AK2pwbuFrAO5t6+Sofph1O7MYFXlwSHtqydgrNy/bE=;
    b=RpBA0sfvOIPSlooflLqEo6vIKaTRZDQZja2aX9m9JsxB0m0IxCsSw+1N+4eJlS4idq
    m+2mZ8+BuAG2HP6PxOu6YI9UODeHdcaNpfVz5l7TzKlRmg+E3cpbaGCOQdRu6fh/lB24
    +ev21eC/rUulKZwM3U5gOst3TmGGrWmIyJfCI57q9/3L2GPg8b0e2foNY8kLJ+82ckBP
    PdXcGpUGPL4M4/St7oYQCtuWk/emuQ0traSN7O+LHJG08YQeA/yozeULtk7zgQyYJcIB
    PYUOJVq6Cl4ZhE4oZPpJsMZkOeeLuv6H9MndNQRKddKQiA7OVmNxUevhMGvOZWDimTHB
    R3ag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788105943;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/AK2pwbuFrAO5t6+Sofph1O7MYFXlwSHtqydgrNy/bE=;
    b=WUXZ8F2Qq+adkPA/Pwn4Tt9JfMMNzU9Q8SgdTGqdMJnOdwkKIzaS7+PleFTA36Z3Xm
    gdewr4CLM8kjx5vYNcBg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/4y2xJGqxKO/71WLEX+9Og/eiUqko/dE="
Received: from p200300c5872968993aedd1469d684940.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127UG5ggkD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 30 Aug 2026 18:05:42 +0200 (CEST)
Message-ID: <0993b0a14b17331dff17dd643be56144d0ae267b.camel@iokpp.de>
Subject: Re: [PATCH v4 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com, sumit.garg@oss.qualcomm.com, 
	jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Date: Sun, 30 Aug 2026 18:05:42 +0200
In-Reply-To: <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
	 <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-27 at 09:03 +0200, Jorge Ramirez-Ortiz wrote:
> The RPMB authentication key is derived from the dev_id handed to the
> RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> is the eMMC CID: a fixed 16-byte value the key derivation depends on.
>=20
> The UFS RPMB id is "<device_id>-R<region>", which is variable length
> and longer than 16 bytes. Handing it to the RPMB subsystem as-is would
> tie the derived key to a length OP-TEE does not expect and diverge from
> the fixed-CID eMMC ABI, forcing OP-TEE to be taught about
> variable-length UFS ids.
>=20
> A fixed 16-byte dev_id is needed so the derived key stays stable and
> unique per region while matching the eMMC CID layout OP-TEE relies on,
> keeping the key-derivation ABI identical with no OP-TEE change. The
> reduction to a fixed 16 bytes must also be reproducible by the
> bootloaders (such as U-Boot) that derive the same dev_id.
>=20
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

I gave my Reviewed-by on v3 2/2 [1], but it seems to have been dropped here=
. If
the patch hasn't changed much, must be picked, add again:


Reviewed-by: Bean Huo <beanhuo@micron.com>


Documentation/process/submitting-patches.rst asks author to carry review ta=
gs
into later versions, and to note it below the '---' when a tag is dropped.

[1]https://lore.kernel.org/all/c041d409bf6f564c6743a0d03e0c851ce3afa6d5.cam=
el@iokpp.de/

Kind regards,
Bean



