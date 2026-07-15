Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFCF37E5E2;
	Wed, 15 Jul 2026 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117621; cv=pass; b=nEB6fxstNiH2VYwf3S5UgH0SkB8O2JvhPZLhms6nFvhQ08t7GWZBNeTvvDseTi+/+xGiQ48VQGEOOj+frDfJQUc8gIjl2t/Jov7XQR7vnhQ5UPIi2dL8trJJmxzms1mpTQ5CC8RG+NiLsR03MmZ/5uS0KEuaAW+OR4Hi2qS2/i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117621; c=relaxed/simple;
	bh=d05XWyMUmUEVHb8Z1aRZUSmfiauT7FWVxU1dxAI3HTo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RT44E440qPaqSYiPuDuQSqGFoBctPbxRCR1XUrtqwOn6/02/Q9/2BiiaquTQoKqVNzF2P0kyxhliu5jZtTw5gXPvQtRLsutFdzINuSd9QNQtmVWwiSqpYcEQVptYg39kSzph+DuRO6t2SmwVv6shUWYLYFuWojk0/RMCbNOYbV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=j+6aOEa4; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TK8uEcF3; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="j+6aOEa4";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TK8uEcF3"
ARC-Seal: i=1; a=rsa-sha256; t=1784117607; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=AYaD5Vn2+z0tPNzV53db60GfdhdhJFdDWB/PMfqasHCCY9rt9slKCqT6ETjPTXyzcJ
    itrSzZUa5TRdodmPmWPhJHoEk51X8gOqVCj3eY9sHiOXvcqfq+tAY2TkNN+1xG0mHz5x
    j1BAJYkGzJ0qHi9JW6bi9gqrKdXkPs2VL1d9RaRX70DA366sb4w+wwTNsUi7+0xOQXxy
    hPXguFuBL1FvkNPK+ChIrmqz1Q+FUh4ww7sgCRbYNItESOgLvW/bE0adjObMGHAm0XXp
    tqeuzAd7Kw9qHVfsCnBMVNO8bHV/Pt5jqerWO/p/i3dC8nKPbOsEDeFcXycj9tk9JP4c
    +hPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784117607;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=d05XWyMUmUEVHb8Z1aRZUSmfiauT7FWVxU1dxAI3HTo=;
    b=s+iZ2VcBdEBkuN0hXPrq/HRL13gidUiMkRK2f2KKLZsa1iyDJEgQrNFb4Pc35rxXyG
    gerNlhihA0YDNC4QHNzok5CqAkbjoFemOdyj77yl5T9UnpPghPMZkjvoshuN3/NI7XkZ
    JnNfrTU6sf3vyo+F4kii9c2UA5Lt3pDc563OiX81m9wfmW6L4NZjyPCc2Ep0BOYdW1Aq
    4S5JSeofzbZ3jbMZR8xvS18C20EwboM7P3VXXw81e3bJ9P44hGxOiSvskD+xJN5gybEE
    b6xPBH+cYVNFEQCKBVTnF34SQvcmKYJMJBcJqb7r0OkpjdPJqWGW5YuQAJ3aBntiL2ee
    5sVg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784117607;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=d05XWyMUmUEVHb8Z1aRZUSmfiauT7FWVxU1dxAI3HTo=;
    b=j+6aOEa4DTaioxTTP0IRLvq9R+t1Cjp+EtmGpmYbuWoHXZ5CyyVNPQup2TTzYA7jGv
    b/a+XVNqlZ+7sHJnJ/uxzLoaSJ3l+ltvXgWKxKJUqZOwYzCnoQD5Rco0BQ+yDuyZIgDz
    5GaPwEhgnSFtwI0JWg++08pixjEAywk4HagSqD1JLVs/NUgJTRFgvvl8p+YxD2NKvTSd
    QmEtrkNzVJWTLKzxSUDdDy7Tw7uLMkDWuhVdxRdCXaEaTs7Pv38F2x6VtHj6k35q5/jQ
    AF+SutmuvwavStOztrKQ+rPf9EV4XkDR6UD/J5PDFCzsSTavWc1GyzJQ1mZGSf6rJwwF
    1bIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784117607;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=d05XWyMUmUEVHb8Z1aRZUSmfiauT7FWVxU1dxAI3HTo=;
    b=TK8uEcF3vUVT8JQwixvml7e6+KtijICPTF1icmhqOsaz2LoOcNVVr3mJpHYgMCXbZ6
    DOhKy7Ijvy2BTROOYuDw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d38826FCDPOLz
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 15 Jul 2026 14:13:25 +0200 (CEST)
Message-ID: <06739c869ab26c2b661ed0b0d7878d27b44ebba3.camel@iokpp.de>
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
From: Bean Huo <beanhuo@iokpp.de>
To: Guangshuo Li <lgs201920130244@gmail.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bart Van
 Assche <bvanassche@acm.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,  Can Guo <can.guo@oss.qualcomm.com>, Adrian
 Hunter <adrian.hunter@intel.com>, Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
 linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Wed, 15 Jul 2026 14:13:25 +0200
In-Reply-To: <20260714172726.1736967-1-lgs201920130244@gmail.com>
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-15 at 01:27 +0800, Guangshuo Li wrote:
> controller.
>=20
> A previous change moved the RTC work cancellation before the PRE_CHANGE
> vendor suspend callback to close a race in the common suspend path.
> However, the active-active path jumps directly to vops_suspend after
> flushing exception handling work and therefore bypasses the
> cancellation.
>=20
> If the RTC work runs while the vendor suspend callback is gating or
> otherwise changing hardware state, it can access the controller during
> suspend and trigger an SError.
>=20
> Cancel the RTC work before entering the vendor suspend callback in the
> active-active path. Since this path now cancels the work, move the RTC
> work scheduling outside the device and link state restoration block in
> the resume path. This restarts RTC updates after an active-active
> suspend and resume cycle.
>=20
> Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() du=
ring
> UFS suspend")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>


Reviewed-by: Bean Huo <beanhuo@micron.com>
