Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795718930;
	b=ZMH/JvtfXtG8cym8phE9WOIKANkoZhs2jfjLE8UzrIISReTLOfmkovhhdQhJVk9Nl75k
	 DvfiC2AAt51X/aBCRzs9RaGWnTyKD4o5bTrs9AG7TgxRq5poTOcsPCAXzwOw0aNLJwJal
	 KYKdVNiNVJrHKZeL6q//cBlzmgy+437LseU0L5lIA4Lvkk7jwMBe4v/iWxBcdiojhno8a
	 lvjUFRGrclThEJJFylXRgfhSeqA/zLUYCaJJG6YPyl+SHhxHo7WliElMO6ow3uN3eW4Pn
	 YlYR3wcnMoYsKR9tajt9+jQIUQySxTA3BB26A/WuXVCkEOSKYu+DEwAenxUIBjQTyXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795718930;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=wHbMfkEgeLbspY0fh0ArFGt8zK65HnmhBzUvEdl637s=;
	b=GCIU4mAFYzhlG7OocyGKjARqLDlOzDSKkhwRqsF5blrKFx2cbLttriPRvtbMiwpVu6gI
	 ZUTXUv1rVdVyGywMKHh6wEQEOYTxmsDjbsUNcibf3ovCv/v+LEnnBXzulwDtKSCpPCugT
	 99nvRhEX9wXZUPLa0di10jwjDDOa9FiwXGBzk2CQEXK0oaUnxB4vtHWM6yXmUpolLSDlX
	 JmPRlpmFI7iNvbty9psbgq2bllame9cc0pcCigRZRYTe6UDXoWhXspWDrcLltBsi8rwSQ
	 jBEeh+M5om+00zIWztchTBWg1rYvV56iuK7qWqj2q5BMEnHYBItUqWXhWjUGjwyMjsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=Kauqt8EY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=Lw36d0A4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.51
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB7606A31C;
	Thu, 26 Nov 2026 18:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EAB7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=Kauqt8EY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=Lw36d0A4
ARC-Seal: i=1; a=rsa-sha256; t=1795718886; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kKM8VgxghK10RHwIhT2P9WI+qUvgvTjsDu4BNZ+dy1tacknF8PJniVc2e41TWOQasQ
    VEn0sAGEiGYhReBsCkLQVQdatwZznhxomiuFXik64aHPVuc+o31uqNFMUXSM/m9OjIbB
    mTGL8Yb4pvNQu2G3O4xRi/5jBzqwsUz1eOjLnr2VFxsT0wYPIxzawZzH/3YOnmx01/9d
    s+C4YG7p0rb7WNFNT5kkxz8DKTZ2aor91mx2EtEP7hstYhhASbszZj1kmx9hapB5n8DV
    DyVwLG4X3RoD6VUesY/BVpt6G8W3pFK38RQFVGy50XcEL1BSdnMxUF3w3XjG38d/5vzN
    v50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795718886;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wHbMfkEgeLbspY0fh0ArFGt8zK65HnmhBzUvEdl637s=;
    b=Gn6YiA5bt0n8lnXSRKf/IF2R3fUBWHEA+rIjnDp2Fj7VVeKx0re5yvYmf3+JsQKYQA
    AliUedSmnROxV+XMHzMhw4anmuKxdeweX/SSyNWtOWocTMP9P3MKdcjAgzW2DHkATcqM
    yWFFtRlo7EiXzzaDzrtTUaMZh1FW1oaFcaF22oKS/WQoTcvi/lQXHHbu0JLq/KCWs2rs
    whLlvdYCz+iEV5BeyzhfQqhfcf/3nn/9t/5BoF+gfwseGUyOEDPkNSlv7lk6pgvKY1JD
    MC5fidZ5+ZBRp4OIqfY4TudxEvQ3ka47WPKBhi5JCvfOt2qNGpuA52aJvIYRmIF1Ssia
    4uXg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795718886;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wHbMfkEgeLbspY0fh0ArFGt8zK65HnmhBzUvEdl637s=;
    b=Kauqt8EY0CcJ9UlKsu2XIgPBQWyBfKWMn7JAOzwF8Eu+zr6jXxMrzebz0cP3iEkZH0
    6W1z0XOs1zLlBujKejnyQL8bIt/cKgnoE2wBYBQuEn3T+3vzcGSX9syxD0ud00a2tHQr
    VuJ2fTrGSh7ueSJ68xjYLMAr2XfjMRV4IuR8qJJT8wPz04OohZYZfSP3drDNItMxXAjI
    t74QT13RLjfO+OQb0/elbzBdj6irLb0Lje4ycd3eqo9h0SJVV2bp7trTmJFFO1D4STkD
    nfGvJHv3rlKlj/l07vPgxvekzIODSLbHi3JmTMhQV8ROyQPS2qAwS0qiMKTNLQfcSl0N
    NhXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795718886;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wHbMfkEgeLbspY0fh0ArFGt8zK65HnmhBzUvEdl637s=;
    b=Lw36d0A4gBLJrk6w/FOkC7rZhMOkf6F8ty1NysrgQoJhH4ftF+1qA2usqagz/wbVBD
    R4pbaz0EF116BVw0QVBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+/rGHySpF6c+UiLF2EuI+KdD9FHsLX5A="
Received: from p200300c58723293d726ec4ea6d904a99.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AQIm6et8
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 26 Nov 2026 19:48:06 +0100 (CET)
Message-ID: <1c0167ce6f039db3453e77b1fa6f8efa193ff4f4.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: rpmb: Return -EIO instead of SCSI result on
 failure
From: Bean Huo <beanhuo@iokpp.de>
To: nayeoni.kim@samsung.com, linux-scsi@vger.kernel.org, "Martin K.
 Petersen" <mkp@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Jorge Ramirez-Ortiz
 <jorge.ramirez@oss.qualcomm.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Bean Huo <beanhuo@micron.com>,
 Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, Stanley
 Jhu <stanleyjhu@google.com>
Date: Thu, 26 Nov 2026 19:48:06 +0100
In-Reply-To: <20261124-b4-ufs-3-rpmb-errno-v1-1-65b54643ca21@samsung.com>
References: <20261124-b4-ufs-3-rpmb-errno-v1-1-65b54643ca21@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-24 at 13:52 +0900, Nayeon Kim via B4 Relay wrote:
> From: Nayeon Kim <nayeoni.kim@samsung.com>
>=20
> rpmb_route_frames() is documented to return a negative errno on
> failure, but ufs_sec_submit() returns the value of scsi_execute_cmd()
> as is. When a SECURITY PROTOCOL IN/OUT command fails, that value is a
> positive SCSI result such as SAM_STAT_CHECK_CONDITION or
> DID_ERROR << 16. ufs_rpmb_route_frames() passes it up and logs it as
> "ret=3D%d". Since scsi_execute_cmd() sets RQF_QUIET, the sense data is
> not logged anywhere.
>=20
> handle_rpc_func_rpmb_frames(), the only caller of rpmb_route_frames(),
> checks for a non-zero return, so OP-TEE still sees the failure.
>=20
> Log the SCSI result and sense data in ufs_sec_submit() and convert
> positive results to -EIO, as ufshcd_set_dev_pwr_mode() does.
>=20
> Signed-off-by: Nayeon Kim <nayeoni.kim@samsung.com>
> ---
> Based on 7.4/scsi-fixes because it depends on commit 7bc9b854cd68
> ("scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF").
> Not urgent; fine for 7.5. Compile-tested (W=3D1) only.
> ---


this time sashiko is right, you need to add a fixes tag.=20

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS
devices")

Reviewed-by: Bean Huo <beanhuo@micron.com>

Kind regards,
Bean


